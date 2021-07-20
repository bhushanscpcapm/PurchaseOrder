namespace bhushan.db;

using {
    bhushan.db.master,
    bhushan.db.transaction
} from './datamodel';


context CDSViews {
    define view![POWorklist] as
        select from transaction.purchaseorder {
            key PO_ID                             as![PurchaseOrderId],
                PARTNER_GUID.BP_ID                as![PartnerId],
                PARTNER_GUID.COMPANY_NAME         as![CompanyName],
                GROSS_AMOUNT                      as![POGrossAmount],
                Currency.code                     as![POCurrencyCode],
                LIFECYCLE_STATUS                  as![POStatus],
            key Items.PO_ITEM_POS                 as![ItemPosition],
                Items.PRODUCT_GUID.PRODUCT_ID     as![ProductId],
                Items.PRODUCT_GUID.DESCRIPTION    as![ProductName],
                PARTNER_GUID.ADDRESS_GUID.COUNTRY as![Country],
                PARTNER_GUID.ADDRESS_GUID.CITY    as![City],
                Items.GROSS_AMOUNT                as![GrossAmount],
                Items.NET_AMOUNT                  as![NetAmount],
                Items.Currency.code               as![CurrencyCode]
        };

    define view ProductVH as
        select from master.product {
            @EndUserText.label : [{
                language : 'EN',
                TEXT     : 'Product Id'
            }, {
                language : 'ES',
                TEXT     : 'Prodekt Id'
            }]
            PRODUCT_ID,
            @EndUserText.label : [{
                language : 'EN',
                TEXT     : 'Product Description'
            }, {
                language : 'ES',
                TEXT     : 'Prodekt Description'
            }]
            DESCRIPTION
        };

    define view![ItemView] as
        select from transaction.poitems {
            PARENT_KEY.PARTNER_GUID.NODE_KEY as![Partner],
            PRODUCT_GUID.NODE_KEY            as![ProductId],
            Currency.code                    as![CurrencyCode],
            GROSS_AMOUNT                     as![GrossAmount],
            NET_AMOUNT                       as![NetAmount],
            TAX_AMOUNT                       as![TaxAmount],
            PARENT_KEY.OVERALL_STATUS        as![POStatus]
        };

    define view ProductViewSub as
        select from master.product as prod {
            PRODUCT_ID        as ![ProductId],
            texts.DESCRIPTION as ![Description],
            (
                select from transaction.poitems as a {
                    SUM(
                        a.GROSS_AMOUNT
                    ) as sum
                }
                where
                    a.PRODUCT_GUID.NODE_KEY = prod.NODE_KEY
            )                 as POSum:Decimal(10, 2)
        };

    define view ProductView as
        select from master.product
        mixin {
            PO_ORDERS : Association[ * ] to ItemView
                            on PO_ORDERS.ProductId = $projection.ProductId
        }
        into {
            NODE_KEY                           as![ProductId],
            DESCRIPTION                        as![Description],
            CATEGORY                           as![Category],
            PRICE                              as![Price],
            TYPE_CODE                          as![TypeCode],
            SUPPLIER_GUID.BP_ID                as![BPId],
            SUPPLIER_GUID.COMPANY_NAME         as![CompanyName],
            SUPPLIER_GUID.ADDRESS_GUID.CITY    as![City],
            SUPPLIER_GUID.ADDRESS_GUID.COUNTRY as![Country],
            //Association
            PO_ORDERS
        };

    define view CProductValueView as
        select from ProductView {
            ProductId,
            Country,
            PO_ORDERS.CurrencyCode as![CurrencyCode],
            sum(
                PO_ORDERS.GrossAmount
            )                      as![POGrossAmount]: Decimal(10,2)

        }
        group by
            ProductId,
            Country,
            PO_ORDERS.CurrencyCode
}
