using {
    managed,
    cuid,
    Currency
} from '@sap/cds/common';
namespace TravelAdmin;



entity Travel : cuid, managed {
    @text                : 'Travel Id'
    travelid      : Integer default 0  @readonly;
    begindate     : Date;
    enddate       : Date;

    @Measures.ISOCurrency: 'currency_code'
    bookingfee    : Decimal(16, 2);

    @Measures.ISOCurrency: 'currency_code'
    totalprice    : Decimal(16, 2)     @readonly;
    currency      : Currency;
    progress      : Integer            @readonly;
    description   : String(1024);
    travelstatus  : String enum {
        Open      = 'O';
        Accepted  = 'A';
        Cancelled = 'C';
    } default 'O';
    to_agency     : String(6);
    to_customer   : String(6);
    to_booking    : Composition of many Booking
                        on to_booking.to_travel = $self;
    lastchangedat : managed:modifiedAt @UI.Hidden: true;
    lastchangedby : managed:modifiedBy @UI.Hidden: true;
}

@cds.autoexpose: true
entity Booking : cuid, managed {
    bookingid         : Integer             @readonly; //@Core.Computed; //or
    bookingdate       : Date;
    connectionid      : String(4);
    flightdate        : Date;

    @Measures.ISOCurrency: 'currency_code'
    flightprice       : Decimal(16, 2);
    currency          : Currency;
    bookingstatus     : String enum {
        New       = 'N';
        Booked    = 'B';
        Cancelled = 'C';
    } default 'N';

    @Measures.ISOCurrency: 'currency_code'
    totalsuppprice    : Decimal(16, 2);
    to_booksupplement : Composition of many BookingSupplement
                            on to_booksupplement.to_booking = $self;
    to_carrier        : String(3);
    to_customer       : String(6);
    to_travel         : Association to Travel; 
    to_flight         : String(3);
    lastchangedat     : managed:modifiedAt @UI.Hidden: true;
    lastchangedby     : managed:modifiedBy @UI.Hidden: true;
}
@cds.autoexpose: true
entity BookingSupplement : cuid, managed {
    bookingsupplementid : Integer            @Core.Computed;

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
    lastchangedat       : managed:modifiedAt @UI.Hidden: true;
    lastchangedby       : managed:modifiedBy @UI.Hidden: true;
}

annotate Travel with {
    lastchangedat @odata.etag;
    createdAt     @UI.Hidden: true;
    createdBy     @UI.Hidden: true
}

annotate Booking with {
    lastchangedat @odata.etag;
    createdAt     @UI.Hidden: true;
    createdBy     @UI.Hidden: true
};

annotate BookingSupplement with {
    lastchangedat @odata.etag;
    createdAt     @UI.Hidden: true;
    createdBy     @UI.Hidden: true
};
