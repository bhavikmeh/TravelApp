using {TravelAdmin as my} from '../db/schema.cds';
using {sap.fe.cap.travel as master} from '../db/master-data';


@path: '/Admin'
service TravelProcess {
    entity Agency    as projection on master.TravelAgency;

    @cds.autoexpose: true
    entity Passenger as projection on master.Passenger;

    @odata.draft.enabled
    entity Travel    as
        projection on my.Travel {
            *,
            // @Common.Text: description  @Common.TextArrangement: #TextOnly
            // travelid,
            // @title      : 'Customer Name'
            // to_customer.FirstName || ' ' || to_customer.LastName as CustomerName : String,
            to_customer.CustomerName as CustomerName,
            to_agency.Name           as AgencyName,
            travelstatus.name        as TravelStatusDet,
            virtual null             as acceptEnabled : Boolean @UI.Hidden,
            virtual null             as rejectEnabled : Boolean @UI.Hidden

        // @Common     : {

        //     Text: CustomerName
        // }
        // to_customer,
        // to_agency.Name                                       as AgencyName,
        // @Common.Text: AgencyName
        //           to_agency,
        // travelstatus.name as TravelStatusDet,
        // @Common     : {
        //     Text: travelstatus.name
        // }
        // travelstatus


        }
        actions {
            action acceptTravel();
            action rejectTravel();
        };
// entity Booking as projection on my.Travel;

}

annotate TravelProcess.Travel with @Common.SemanticKey: [travelid];
annotate TravelProcess.Booking with @Common.SemanticKey: [bookingid];
annotate TravelProcess.BookingSupplement with @Common.SemanticKey: [bookingsupplementid];

annotate TravelProcess.Travel with {
    travelid     @Common.Text: description;
    to_customer  @Common.Text: CustomerName  @Common.TextArrangement: #TextOnly;
    to_agency    @Common.Text: AgencyName;
    travelstatus @Common.Text: TravelStatusDet;

};

// Setting up Refresh whenever booking fee is changed so that Total price is updated
annotate TravelProcess.Travel with @(Common.SideEffects: {
    SourceProperties: [bookingfee],
    TargetProperties: ['totalprice']
});


annotate TravelProcess.Travel with actions {

    //OPTION 1 if it is simple
    // acceptTravel @(
    //     Core.OperationAvailable            : {$edmJson: {$Ne: [
    //         {$Path: 'in/travelstatus_code'},
    //         'A'
    //     ]}},
    //     Common.SideEffects.TargetProperties: ['in/travelstatus_code','in/progress']
    // );

    // rejectTravel @(
    //     Core.OperationAvailable            : {$edmJson: {$Ne: [
    //         {$Path: 'in/travelstatus_code'},
    //         'X'
    //     ]}},
    //     Common.SideEffects.TargetProperties: ['in/travelstatus_code','in/progress']
    // );
    // OPTION 2 if it is too complex
    rejectTravel @(
        Core.OperationAvailable            : in.rejectEnabled,
        Common.SideEffects.TargetProperties: [
            'in/travelstatus_code',
            'in/acceptEnabled',
            'in/rejectEnabled',
            'in/progress'
        ],
    );
    acceptTravel @(
        Core.OperationAvailable            : in.acceptEnabled,
        Common.SideEffects.TargetProperties: [
            'in/travelstatus_code',
            'in/acceptEnabled',
            'in/rejectEnabled',
            'in/progress'
        ],
    );
}
