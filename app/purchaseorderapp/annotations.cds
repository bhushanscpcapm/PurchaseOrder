using {CatalogService} from '../../srv/CatalogService';


//Annotation for First screen
//Property Level annotation
annotate CatalogService.POSet with {
    PARTNER_GUID @(
        common           : {Text : COMPANY_NAME, },
        ValueList.entity : CatalogService.BPSet
    )

};

@cds.odata.valuelist
annotate CatalogService.BPSet with @(UI : {Identification : [{
    $Type : 'UI.DataField',
    Value : COMPANY_NAME
}

], });


annotate CatalogService.POSet with @(UI : {
    SelectionFields               : [
        PO_ID,
        GROSS_AMOUNT,
        LIFECYCLE_STATUS,
        Currency.code
    ],

    LineItem                      : [
        {
            $Type : 'UI.DataField',
            Value : PO_ID,
        },

        {
            $Type : 'UI.DataField',
            Value : GROSS_AMOUNT,
        },
        {
            $Type  : 'UI.DataFieldForAction',
            Label  : 'Boost',
            Action : 'CatalogService.boost',
            Inline : true
        },

        {
            $Type : 'UI.DataField',
            Value : Currency.code,
        },

        {
            $Type : 'UI.DataField',
            Value : PARTNER_GUID.COMPANY_NAME,
        },

        {
            $Type : 'UI.DataField',
            Value : PARTNER_GUID.ADDRESS_GUID.COUNTRY,
        },
        {
            $Type : 'UI.DataField',
            Value : TAX_AMOUNT,
        },
        {
            $Type                     : 'UI.DataField',
            Value                     : LIFECYCLE_STATUS,
            Criticality               : Criticality,
            CriticalityRepresentation : #WithIcon,
        }

    ],
    HeaderInfo                    : {
        $Type          : 'UI.HeaderInfoType',
        TypeName       : '{i18n>PurchaseOrder}',
        TypeNamePlural : '{i18n>PurchaseOrders}',
        Title          : {
            Label : '{i18n>POID}',
            Value : PO_ID,
        },
        Description    : {
            Label : '{i18n>Desc}',
            Value : PARTNER_GUID.COMPANY_NAME,
        },
    },

    Facets                        : [
        {
            $Type  : 'UI.ReferenceFacet',
            Label  : '{i18n>POHeader}',
            Target : ![@UI.FieldGroup#HeaderGeneralInfo],
        },
        {
            $Type  : 'UI.ReferenceFacet',
            Label  : 'PO Items',
            Target : 'Items/@UI.LineItem',
        }

    ],

    FieldGroup #HeaderGeneralInfo : {
        $Type : 'UI.FieldGroupType',
        Data  : [
            {
                $Type : 'UI.DataField',
                Value : PO_ID,
            },
            {
                $Type : 'UI.DataField',
                Value : PARTNER_GUID_NODE_KEY,
            },

            {
                $Type : 'UI.DataField',
                Value : PARTNER_GUID.COMPANY_NAME,
            },

            {
                $Type : 'UI.DataField',
                Value : PARTNER_GUID.BP_ID,
            },

            {
                $Type : 'UI.DataField',
                Value : GROSS_AMOUNT,
            },
            {
                $Type : 'UI.DataField',
                Value : NET_AMOUNT,
            },
            {
                $Type : 'UI.DataField',
                Value : TAX_AMOUNT,
            },
            {
                $Type : 'UI.DataField',
                Value : Currency.code,
            },
            {
                $Type : 'UI.DataField',
                Value : LIFECYCLE_STATUS,
            },
        ]

    },
}

);

annotate CatalogService.POItemSet with @(UI : {LineItem : [
    {
        $Type : 'UI.DataField',
        Value : PO_ITEM_POS,
    },
    {
        $Type : 'UI.DataField',
        Value : PRODUCT_GUID_NODE_KEY,
    },
    {
        $Type : 'UI.DataField',
        Value : PRODUCT_GUID.PRODUCT_ID,
    },
    {
        $Type : 'UI.DataField',
        Value : GROSS_AMOUNT,
    },
    {
        $Type : 'UI.DataField',
        Value : Currency.code,
    }
],

}

);
