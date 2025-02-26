using TravelProcess as service from '../../srv/schema';
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
    CustomerID @Common.Text : CustomerName
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

