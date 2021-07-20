using {bhushan.db.CDSViews} from '../db/CDSViews';
using {
    bhushan.db.master,
    bhushan.db.transaction
} from '../db/datamodel';


service CDSService @(path : '/CDSService') {
    entity POWorkList as projection on CDSViews.POWorklist;
entity ProductAggregation as projection on CDSViews.CProductValueView;

}
