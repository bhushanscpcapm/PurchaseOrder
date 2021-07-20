module.export = cds.service.impl(async function () {

    const {
        EmployeeSet,
        POSet
    } = this.entities;

    this.before('UPDATE', EmployeeSet, (req, res) => {
        if (parseFloat(req.data.salaryAmount) > 100000) {
            req.console.error(500, "Salary must be below 1MN");
        }

    });

    this.after("READ", EmployeeSet, async (req, res) => {
        console.log("I am Employee");
    });

    this.on('boost', async req => {
        try {

            const ID = req.params[0];
            console.log("Your Purchase ID Number: ", + ID);
            const tx = cds.tx(req);
            await tx.update(POSet).with({
                GROSS_AMOUNT: { '+=': 2000 },
                NOTE: 'Boosted||'
            });
            return "Boost was successful";

        } catch (error) {
            return "Error:" + error.toString();
        }
    });

    this.on('largeOrder', async req => {
        try {

            const ID = req.params[0];
            console.log("Your Purchase ID Number: ", + ID);
            const tx = cds.tx(req);
            const reply = await tx.read(POSet).orderBy({
                GROSS_AMOUNT: 'desc'
            }).limit(1);

            return reply;

        } catch (error) {
            return "Error:" + error.toString();
        }
    });

});