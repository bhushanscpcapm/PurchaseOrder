using {bhushan.db.master, bhushan.db.transaction } from '../db/datamodel';

service mysimpleservice  {
 @readonly
 entity ReadEmployeeSrv as projection on master.employees;
 @Insertonly
 entity InsertEmployeeSrv as projection on master.employees;
 @Updateonly
 entity UpdateEmployeeSrv as projection on master.employees;
 @deleteonly
 entity DeleteEmployeeSrv as projection on master.employees;
}