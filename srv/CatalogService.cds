using {
    bhushan.db.master,
    bhushan.db.transaction
} from '../db/datamodel';

service CatalogService @(path : 'CatalogService')@(requires : 'authenticated-user') {
    @Capabilities : {
        Insertable,
        Updatable,
        Readable,
        Deletable : false
    }
    entity EmployeeSet @(restrict : [
        {
            grant : ['READ'],
            to    : 'Viewer',
            where : 'bankname = $user.BankName'
        },
        {
            grant : ['WRITE'],
            to    : 'Admin'
        }
    ])                                          as projection on master.employees;

    entity AddressSet                           as projection on master.address;
    entity ProductSet                           as projection on master.product;
    entity BPSet                                as projection on master.businesspartner;

    entity POSet @(
        title               : '{i18n>poHeader}',
        odata.draft.enabled : true
    )                                           as projection on transaction.purchaseorder {
        * , case LIFECYCLE_STATUS
                when
                    'N'
                then
                    'New'
                when
                    'D'
                then
                    'Delivered'
                when
                    'B'
                then
                    'Blocked'
            end as LIFECYCLE_STATUS : String(20),

                                                  case LIFECYCLE_STATUS
                                                      when
                                                          'N'
                                                      then
                                                          2
                                                      when
                                                          'D'
                                                      then
                                                          1
                                                      when
                                                          'B'
                                                      then
                                                          3
                                                  end as Criticality : Integer, Items : redirected to POItemSet
    } actions {
        function largeOrder() returns array of POSet;
        action boost();
    };

    entity POItemSet @(title : '{i18n>poItem}') as projection on transaction.poitems {
        * , PARENT_KEY : redirected to POSet, PRODUCT_GUID : redirected to ProductSet
    }

}
