const cds = require('@sap/cds');

class TravelProcess extends cds.ApplicationService {    
    init() {

        this.bookingFee = 0;
        this.travelFee  = 0;

        const { Travel, Booking } = this.entities;
        this.before('CREATE', 'Travel', async (req) => {
            const { maxId } = await SELECT.one`max(travelid) as maxId`.from(Travel);
            req.data.travelid = maxId + 1;

        });

        // Validation before save
        // You can also USE .ON CREATE for TRAVEL, you can try TRAVEL.DRAFT also
        this.before('SAVE', 'Travel', async (req) => {
            const { begindate, enddate } = req.data;
            const today = (new Date).toISOString().slice(0, 10); //CAP Date format internal
            if (begindate < today) { req.error(`Begin Date ${begindate} must not be before today ${today}.`, 'in/begindate'); return; };
            if (enddate < begindate) { req.error(400, `Begin Date ${begindate} must be before End Date ${enddate}.`, 'in/enddate'); return; };
            if(req.event === 'CREATE' || req.event === 'UPDATE'){
                let score = 10;
                const res = await SELECT  .from(Booking.drafts) .where `to_travel_ID = ${req.data.ID}`;
                if (res.length > 1 ){score  += 45;}
                if (res.length > 2 ){score  += 15;}
                req.data.progress = score;
            }
        });

        this.after('UPDATE', 'Travel.drafts', (gg, req) => {
            if ('bookingfee' in req.data) {              
                return this.updtot(req.data.ID);
            }
        });

        this.after('UPDATE', 'Booking.drafts', async (gg,req)=>{
            if('flightprice' in req.data){
                const {travelid} = await SELECT .one `to_travel_ID as travelid` .from(Booking.drafts) .where `ID = ${req.data.ID}`
                return this.updtot(travelid);
            }
        })

        this.before('CREATE', 'Booking.drafts', async(req)=>{
            const {Booking} = this.entities;
            const {maxId}  = await SELECT .one `max(bookingid) as maxId` .from(Booking) .where `to_travel_ID = ${req.data.to_travel_ID}`;
            const {maxIdD} = await SELECT .one `max(bookingid) as maxIdD` .from(Booking.drafts) .where `to_travel_ID = ${req.data.to_travel_ID}`;
            req.data.bookingid = maxId >= maxIdD ? maxId + 1 : maxIdD + 1;
            req.data.bookingdate = (new Date).toISOString().slice(0,10);
            req.data.bookingstatus_code = 'N';
        })

        this.on('acceptTravel', async (req) => {
            // const{Travel} = this.entities;
            // const{ID} = req.data;            
            await UPDATE(req.subject).with`travelstatus_code ='A'`;
            this.updTravelProgress(req.subject,100);
        })

        this.on('rejectTravel', async (req) => {
            var status = 'X';
            await UPDATE(req.subject).with`travelstatus_code ='X'`;
            this.updTravelProgress(req.subject,0);
        })

        this.updTravelProgress = async function (travel,percent) {
            await UPDATE (travel) .with `progress = ${percent}`;
        }

        const _calculateButtonAvailability = any => {
            const status = any.travelstatus && any.travelstatus.code || any.travelstatus_code
            any.acceptEnabled = status !== 'A'
            any.rejectEnabled = status !== 'X'            
          }
          this.after ('each', 'Travel', _calculateButtonAvailability)
          this.after ('EDIT', 'Travel', _calculateButtonAvailability)          
        this.updtot =  async function (travelid) {
            const { BookingFees } =  await SELECT .one `bookingfee as BookingFees`.from(Travel.drafts) .where`ID=${travelid}`;
            const {totBooking} = await SELECT .one `sum(flightprice) as totBooking` .from(Booking.drafts) .where `to_travel_ID = ${travelid}`;
            let score = BookingFees + totBooking;
            return UPDATE (Travel.drafts) .with `totalprice = ${score}`.where`ID=${travelid}`;
        }
        return super.init();
    }

}
module.exports = TravelProcess;