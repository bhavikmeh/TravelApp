const cds = require('@sap/cds');

class TravelProcess extends cds.ApplicationService {
    init() {

        const { Travel } = this.entities;
        this.before('CREATE', 'Travel', async (req) => {
            const { maxId } = await SELECT.one`max(travelid) as maxId`.from(Travel);
            req.data.travelid = maxId + 1;

        });

        // Validation before save
        // You can also USE .ON CREATE for TRAVEL, you can try TRAVEL.DRAFT also
        this.before('SAVE', 'Travel', (req) => {
            const { begindate, enddate } = req.data;
            const today = (new Date).toISOString().slice(0, 10); //CAP Date format internal
            if (begindate < today) { req.error(`Begin Date ${begindate} must not be before today ${today}.`, 'in/begindate') };
            if (enddate < begindate) { req.error(400, `Begin Date ${begindate} must be before End Date ${enddate}.`, 'in/enddate') };
        });

        this.after('UPDATE', 'Travel.drafts', async (gg, req) => {
            if ('bookingfee' in req.data) {                
                this.updtot(req.data.ID);
            }
        });
        this.on('acceptTravel', async (req) => {
            // const{Travel} = this.entities;
            // const{ID} = req.data;
            var status = 'A';
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
        this.updtot = async function (travelid) {
            const { BookingFees } = await SELECT .one `bookingfee as BookingFees`.from(Travel.drafts) .where`ID=${travelid}`;
            return await UPDATE (Travel.drafts) .with `totalprice = ${BookingFees}`.where`ID=${travelid}`;
        }
        return super.init();
    }

}
module.exports = TravelProcess;