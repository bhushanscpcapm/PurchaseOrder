const cds = require("@sap/cds");
const { employee } = cds.entities("bhushan.db.master");

module.export = async function (srv) {

    srv.on("READ", "ReadEmployeeSrv", async (req, res) => {
        var results = [];

        //CDS Query language => Database agnostic 
        //results = await cds.tx(req).run(select.from(employee).limit(3));

        //CDS query read single records with where
        //results = await cds.tx(req).run(select.from(employee).where({"nameFirst" : "Susan"}));

        //CDS query if user pass key like /Entity/Key
        let whereCondition = req.data;

        if (whereCondition.hasOwnProperty("ID")) {
            results = await cds.tx(req).run(select.from(employee).where(whereCondition));
        } else {
            results = await cds.tx(req).run(select.from(employee).limit(1));
        }
        return results;
    });


    function makeid(length) {
        var result = '';
        var characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
        var charactersLength = characters.length;
        for (var i = 0; i < length; i++) {
            result += characters.charAt(Math.floor(Math.random() *
                charactersLength));
        }
        return result;
    };


    //Insert Operation
    srv.on("CREATE", "InsertEmployeeSrv", async (req, res) => {
        var dataSet = [];
        //Add Random ID to Dataset
        for (let index = 0; index < req.data.length; index++) {
            const element = req.data[index];
            element.ID = makeid(32);
            dataSet.push(element);
        }

        let resturnData = await cds.transaction(req).run([
            INSERT.into(employee).entries([req.data])
        ]).then((resolve, reject) => {
            if (typeof (resolve) !== undefined) {
                return req.data;
            } else {
                res.error(500, "There was issue in insert of data");
            }


        }).catch(error => {
            req.error(500, error.toString());
        });

        return returnData;
    });


    srv.on("UPDATE", "UpdateEmployeeSrv", async (req, res) => {
        let returnData = cds.transaction(req).run(
            [
                UPDATE(employee).set({
                    nameFirst: req.data.nameFirst
                }).where({ "ID": req.data.ID }),

                UPDATE(employee).set({
                    nameLast: req.data.nameLast
                }).where({ "ID": req.data.ID })

            ]
        ).then((resolve, reject) => {
            if (typeof (resolve) !== undefined) {
                return req.data;
            } else {
                res.error(500, "There was issue in insert of data");
            }

        }).catch(error => {
            req.error(500, error.toString());
        })
        return returnData;
    });

    srv.on("DELETE", "DeleteEmployeeSrv", async (req, res) => {
        let returnData = cds.transaction(req).run(
            [
                DELETE(employee).where(req.data)

            ]
        ).then((resolve, reject) => {
            if (typeof (resolve) !== undefined) {
                return req.data;
            } else {
                res.error(500, "There was issue in insert of data");
            }

        }).catch(error => {
            req.error(500, error.toString());
        })
        return returnData;
    });
}   
