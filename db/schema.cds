using {
    managed,
    cuid,    
    sap.common.CodeList,
    Currency
} from '@sap/cds/common';
using { sap.fe.cap.travel.TravelAgency, sap.fe.cap.travel.Passenger, sap.fe.cap.travel.Flight,
sap.fe.cap.travel.Airline } from './master-data';


namespace TravelAdmin;


@cds.search: {
    travelid,         // included
    description : true,  // included
    to_agency : false, // excluded
    to_customer           // extend to searchable elements in target entity
    // assoc2.elementA   // extend to a specific element in target entity
}
entity Travel : cuid, managed {
    @title                : 'Travel Id'
    @readonly  
    @Common.Text: description
    @Search.ranking: LOW
    travelid     : Integer default 0;

    @title                : '{i18n>StartDate}'
    begindate    : Date;

    @title                : '{i18n>EndDate}'
    enddate      : Date;

    
    @title                : 'Booking Fees'
    @Measures.ISOCurrency: CurrencyCode_code //This is for Getting Currency Along with Amount    
    bookingfee   : Decimal(16, 2);

    @Measures.ISOCurrency: CurrencyCode_code
    
    @title                : 'Total Price'    
    totalprice   : Decimal(16, 2)     @readonly;

    @text                : 'Currency Code'
    CurrencyCode         : Currency;

    @title               : '{i18n>Progress}'
    progress     : Integer default 0            @readonly ;

    @title               : '{i18n>Description}'
    @Search.ranking: HIGH
    @Search.fuzzinessThreshold: 0.7
    description  : String(1024);

    @title               : '{i18n>TravelStatus}'
    travelstatus : Association to TravelStatus;

    @title               : '{i18n>Agency}'
    to_agency    : Association to TravelAgency @assert.target;

    @title               : '{i18n>Customer}'
    to_customer  : Association to Passenger @assert.target;
    to_booking   : Composition of many Booking
                       on to_booking.to_travel = $self;
                       

}

@cds.search: {
    bookingid             
}
entity Booking : cuid, managed {
    @title : 'Booking Id'
    bookingid         : Integer @Core.Computed;
    @title : 'Booking Date'
    bookingdate       : Date;
    @title : 'Flight Number'
    connectionid      : String(4);
    @title : 'Flight Date'
    flightdate        : Date;

    @Measures.ISOCurrency: currency_code
    @title : 'Flight Price'
    flightprice       : Decimal(16, 2);
    currency          : Currency;
    @title : 'Booking Status'
    bookingstatus     : Association to BookingStatus;
    @Measures.ISOCurrency: currency_code
    totalsuppprice    : Decimal(16, 2);
    to_booksupplement : Composition of many BookingSupplement
                            on to_booksupplement.to_booking = $self;
    @title : 'Airline'                        
    to_carrier        : Association to one Airline;
    @title : 'Customer'
    to_customer       : Association to one Passenger;
    to_travel         : Association to Travel;    
    to_flight         : Association to one Flight
                                on  to_flight.AirlineID    = to_carrier.AirlineID
                                and to_flight.FlightDate   = flightdate
                                and to_flight.ConnectionID = connectionid;

}


entity BookingSupplement : cuid, managed {
    bookingsupplementid : Integer @Core.Computed;

    @Measures.ISOCurrency: 'currency_code'
    price               : Decimal(16, 2);
    deliverypreference  : String enum {
        SoonAfterTakeoff = 'S';
        Midflight        = 'M';
        Late             = 'L';
    } default 'M';
    currency            : Currency;
    to_booking          : Association to Booking;
    to_travel           : Association to Travel;
    to_supplement       : String(10);

}

entity TravelStatus : CodeList {
    key code                    : String enum {
            Open     = 'O';
            Accepted = 'A';
            Canceled = 'X';
        } default 'O';
        criticality             : Integer;
        fieldControl            : Integer;
        createDeleteHidden      : Boolean;
        insertDeleteRestriction : Boolean;
        cancelRestrictions      : Boolean;
}

entity BookingStatus : CodeList {
    key code : String enum {
            New      = 'N';
            Booked   = 'B';
            Canceled = 'X';
        };
}


annotate Travel with {
    modifiedAt  @odata.etag  @UI.Hidden: true;
    modifiedBy  @UI.Hidden: true;
    createdAt   @UI.Hidden: true;
    createdBy   @UI.Hidden: true
}

annotate Booking with {
    modifiedAt  @odata.etag  @UI.Hidden: true;
    modifiedBy  @UI.Hidden: true;
    createdAt   @UI.Hidden: true;
    createdBy   @UI.Hidden: true
};

annotate BookingSupplement with {
    modifiedAt  @odata.etag  @UI.Hidden: true;
    modifiedBy  @UI.Hidden: true;
    createdAt   @UI.Hidden: true;
    createdBy   @UI.Hidden: true
};
