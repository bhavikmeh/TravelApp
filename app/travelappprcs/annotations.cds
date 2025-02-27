using TravelProcess as service from '../../srv/schema';
using from '../../db/schema';

annotate service.Travel with @(
    UI.FieldGroup #GeneratedGroup : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Label : '{i18n>TravelId1}',
                Value : travelid,
            },
            {
                $Type : 'UI.DataField',
                Value : description,
            },
            {
                $Type : 'UI.DataField',
                Label : '{i18n>StartDate}',
                Value : begindate,
            },
            {
                $Type : 'UI.DataField',
                Label : '{i18n>EndDate}',
                Value : enddate,
            },
            {
                $Type : 'UI.DataField',
                Label : '{i18n>BookingFees}',
                Value : bookingfee,
            },
            {
                $Type : 'UI.DataField',
                Label : '{i18n>TotalPrice}',
                Value : totalprice,
            },
            {
                $Type : 'UI.DataField',
                Label : '{i18n>Agency}',
                Value : to_agency_AgencyID,
            },
            {
                $Type : 'UI.DataField',
                Label : '{i18n>Customer}',
                Value : to_customer_CustomerID,
            },
        ],
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'GeneratedFacet1',
            Label : 'General Information',
            Target : '@UI.FieldGroup#GeneratedGroup',
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : '{i18n>Bookings}',
            ID : 'i18nBookings',
            Target : 'to_booking/@UI.SelectionPresentationVariant#i18nBookings',
        },
    ],
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Label : 'Travel Id',
            Value : travelid,
            ![@UI.Importance] : #High,
        },
        {
            $Type : 'UI.DataField',
            Value : to_customer_CustomerID,
            ![@UI.Importance] : #High,
        },
        {
            $Type : 'UI.DataField',
            Label : '{i18n>StartDate}',
            Value : begindate,
            ![@UI.Importance] : #High,
        },
        {
            $Type : 'UI.DataField',
            Value : travelstatus_code,
            Criticality : travelstatus.criticality,
            CriticalityRepresentation : #WithIcon,
            ![@UI.Importance] : #High,
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action : 'TravelProcess.acceptTravel',
            Label : '{i18n>Approve}',
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action : 'TravelProcess.rejectTravel',
            Label : '{i18n>Reject}',
        },
    ],
    UI.SelectionFields : [
        to_agency_AgencyID,
        begindate,
        travelstatus_code,
        to_customer_CustomerID,
    ],
    UI.HeaderFacets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'totalprice',
            Target : '@UI.DataPoint#totalprice',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'travelstatus_code',
            Target : '@UI.DataPoint#travelstatus_code',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'progress',
            Target : '@UI.DataPoint#progress',
        },
    ],
    UI.FieldGroup #NewTravel : {
        $Type : 'UI.FieldGroupType',
        Data : [
            
        ],
    },
    UI.Identification : [
        {
            $Type : 'UI.DataFieldForAction',
            Action : 'TravelProcess.acceptTravel',
            Label : '{i18n>AcceptTravel}',
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action : 'TravelProcess.rejectTravel',
            Label : '{i18n>RejectTravel}',
        },
    ],
    UI.DataPoint #progress : {
        $Type : 'UI.DataPointType',
        Value : progress,
        Title : '{i18n>Progress}',
        TargetValue : 100,
        Visualization : #Progress,
        Description : '',
    },
    UI.DataPoint #totalprice : {
        $Type : 'UI.DataPointType',
        Value : totalprice,
        Title : '{i18n>TotalPrice}',
    },
    UI.DataPoint #travelstatus_code : {
        $Type : 'UI.DataPointType',
        Value : travelstatus_code,
        Title : '{i18n>TravelStatus}',
    },
    UI.SelectionPresentationVariant #table : {
        $Type : 'UI.SelectionPresentationVariantType',
        PresentationVariant : {
            $Type : 'UI.PresentationVariantType',
            Visualizations : [
                '@UI.LineItem',
            ],
            SortOrder : [
                {
                    $Type : 'Common.SortOrderType',
                    Property : travelid,
                    Descending : false,
                },
            ],
        },
        SelectionVariant : {
            $Type : 'UI.SelectionVariantType',
            SelectOptions : [
            ],
        },
    },
    UI.HeaderInfo : {
        TypeName : 'Travel',
        TypeNamePlural : 'Travels',
    },
);

annotate service.Travel with {
    to_customer @(
        Common.ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'Passenger',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : to_customer_CustomerID,
                    ValueListProperty : 'CustomerID',
                },
                {
                    $Type : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'FirstName',
                },
                {
                    $Type : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'LastName',
                },
                {
                    $Type : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'Title',
                },
                {
                    $Type : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'Street',
                },
            ],
        Label : '{i18n>SelectCustomer}',
        },
        Common.ValueListWithFixedValues : false,
        )
};

annotate service.Travel with {
    begindate @(
        Common.Label : '{i18n>StartDate}',
        Common.FieldControl : #Mandatory,
    )
};

annotate service.Travel with {
    travelstatus @(
        Common.Text : {
            $value : TravelStatusDet,
            ![@UI.TextArrangement] : #TextFirst
        },
        Common.ValueListWithFixedValues : true,
        )
};

annotate service.Agency with {
    AgencyID @Common.Text : Name
};

annotate service.Travel with {
    to_agency @(
        Common.ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'Agency',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : to_agency_AgencyID,
                    ValueListProperty : 'AgencyID',
                },
                {
                    $Type : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'Name',
                },
                {
                    $Type : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'Street',
                },
                {
                    $Type : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'City',
                },
                {
                    $Type : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'PostalCode',
                },
                {
                    $Type : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'PhoneNumber',
                },
            ],
        },
        Common.ValueListWithFixedValues : false,
    )
};

annotate service.Passenger with {
    CustomerID @Common.Text : {
        $value : CustomerName,
        ![@UI.TextArrangement] : #TextFirst
    }
};

annotate service.Travel with {
    description @(
        UI.MultiLineText : true,
        Common.FieldControl : #Mandatory,
    )
};

annotate service.Travel with {
    enddate @Common.FieldControl : #Mandatory
};

annotate service.Booking with @(
    UI.LineItem #i18nBookings : [
        {
            $Type : 'UI.DataField',
            Value : bookingid,
        },
        {
            $Type : 'UI.DataField',
            Value : bookingdate,
        },
        {
            $Type : 'UI.DataField',
            Value : to_customer_CustomerID,
        },
        {
            $Type : 'UI.DataField',
            Value : to_carrier_AirlineID,
        },
        {
            $Type : 'UI.DataField',
            Value : connectionid,
        },
        {
            $Type : 'UI.DataField',
            Value : flightdate,
        },
    ],
    UI.SelectionPresentationVariant #i18nBookings : {
        $Type : 'UI.SelectionPresentationVariantType',
        PresentationVariant : {
            $Type : 'UI.PresentationVariantType',
            Visualizations : [
                '@UI.LineItem#i18nBookings',
            ],
            SortOrder : [
                {
                    $Type : 'Common.SortOrderType',
                    Property : bookingdate,
                    Descending : false,
                },
            ],
        },
        SelectionVariant : {
            $Type : 'UI.SelectionVariantType',
            SelectOptions : [
            ],
        },
    },
    UI.HeaderFacets : [
        
    ],
    UI.FieldGroup #i18nBooking : {
        $Type : 'UI.FieldGroupType',
        Data : [
        ],
    },
    UI.Facets : [
        {
            $Type : 'UI.CollectionFacet',
            Label : '{i18n>GeneralInformation}',
            ID : 'Booking',
            Facets : [
                {
                    $Type : 'UI.ReferenceFacet',
                    Label : 'Booking',
                    ID : 'Booking1',
                    Target : '@UI.FieldGroup#Booking',
                },
                {
                    $Type : 'UI.ReferenceFacet',
                    Label : 'Flight',
                    ID : 'Flight',
                    Target : '@UI.FieldGroup#Flight',
                },
            ],
        },
    ],
    UI.FieldGroup #Booking : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : bookingid,
            },
            {
                $Type : 'UI.DataField',
                Value : bookingdate,
            },
            {
                $Type : 'UI.DataField',
                Value : to_customer_CustomerID,
            },
            {
                $Type : 'UI.DataField',
                Value : bookingstatus_code,
            },
        ],
    },
    UI.FieldGroup #Flight : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : to_carrier_AirlineID,
            },
            {
                $Type : 'UI.DataField',
                Value : connectionid,
            },
            {
                $Type : 'UI.DataField',
                Value : flightdate,
            },
            {
                $Type : 'UI.DataField',
                Value : flightprice,
            },
        ],
    },
    UI.HeaderInfo : {
        TypeName : 'Booking',
        TypeNamePlural : 'Bookings',
        Title : {
            $Type : 'UI.DataField',
            Value : to_customer_CustomerID,
        },
    },
);

annotate service.Booking with {
    to_carrier @(
        Common.Text : {
            $value : to_carrier.Name,
            ![@UI.TextArrangement] : #TextFirst
        },
        Common.ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'Airline',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : to_carrier_AirlineID,
                    ValueListProperty : 'AirlineID',
                },
                {
                    $Type : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'Name',
                },
                {
                    $Type : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'CurrencyCode_code',
                },
            ],
            Label : 'Select Airline',
        },
        Common.ValueListWithFixedValues : false,
    )
};

annotate service.Booking with {
    to_customer @(
        Common.Text : {
            $value : to_customer.CustomerName,
            ![@UI.TextArrangement] : #TextFirst
        },
        Common.ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'Passenger',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : to_customer_CustomerID,
                    ValueListProperty : 'CustomerID',
                },
                {
                    $Type : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'FirstName',
                },
                {
                    $Type : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'LastName',
                },
                {
                    $Type : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'City',
                },
                {
                    $Type : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'Street',
                },
                {
                    $Type : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'PostalCode',
                },
                {
                    $Type : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'CountryCode_code',
                },
            ],
            Label : 'Select Customer',
        },
        Common.ValueListWithFixedValues : false,
    )
};

annotate service.BookingStatus with {
    code @Common.Text : {
        $value : name,
        ![@UI.TextArrangement] : #TextFirst
    }
};

annotate service.Airline with {
    AirlineID @Common.Text : {
        $value : Name,
        ![@UI.TextArrangement] : #TextFirst,
    }
};

annotate service.Booking with {
    connectionid @(Common.ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'FLight',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : connectionid,
                    ValueListProperty : 'ConnectionID',
                },
                {
                    $Type : 'Common.ValueListParameterInOut',
                    ValueListProperty : 'AirlineID',
                    LocalDataProperty : to_carrier_AirlineID,
                },
                {
                    $Type : 'Common.ValueListParameterInOut',
                    ValueListProperty : 'FlightDate',
                    LocalDataProperty : flightdate,
                },
                {
                    $Type : 'Common.ValueListParameterInOut',
                    ValueListProperty : 'Price',
                    LocalDataProperty : flightprice,
                },
                {
                    $Type : 'Common.ValueListParameterInOut',
                    ValueListProperty : 'CurrencyCode_code',
                    LocalDataProperty : currency_code,
                },
            ],
            Label : 'Select Flight Number',
        },
        Common.ValueListWithFixedValues : false
)};

annotate service.Booking with {
    flightdate @(Common.ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'FLight',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : flightdate,
                    ValueListProperty : 'FlightDate',
                },
                {
                    $Type : 'Common.ValueListParameterInOut',
                    ValueListProperty : 'AirlineID',
                    LocalDataProperty : to_carrier_AirlineID,
                },
                {
                    $Type : 'Common.ValueListParameterInOut',
                    ValueListProperty : 'ConnectionID',
                    LocalDataProperty : connectionid,
                },
                {
                    $Type : 'Common.ValueListParameterInOut',
                    ValueListProperty : 'Price',
                    LocalDataProperty : flightprice,
                },
                {
                    $Type : 'Common.ValueListParameterInOut',
                    ValueListProperty : 'CurrencyCode_code',
                    LocalDataProperty : currency_code,
                },
            ],
            Label : 'Select Flight Date',
        },
        Common.ValueListWithFixedValues : false
)};

annotate service.Booking with {
    bookingstatus @Common.ValueListWithFixedValues : true
};

