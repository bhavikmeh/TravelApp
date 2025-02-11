using {TravelAdmin as my} from '../db/schema.cds';

@path: '/Admin'
service TravelProcess {
    @odata.draft.enabled
    entity Travel as projection on my.Travel;

}

annotate TravelProcess.Travel with @Common.SemanticKey: [travelid];
annotate TravelProcess.Booking with @Common.SemanticKey: [bookingid];
annotate TravelProcess.BookingSupplement with @Common.SemanticKey: [bookingsupplementid];