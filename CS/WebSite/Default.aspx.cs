using System;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using DevExpress.Web.ASPxScheduler;
using DevExpress.XtraScheduler;
using DevExpress.Web.ASPxScheduler.Internal;
using DevExpress.Web.ASPxGridView;
using DevExpress.Web.ASPxHiddenField;

public partial class _Default : System.Web.UI.Page {
    private int lastInsertedAppointmentId;
   
    void Page_Load(object sender, EventArgs e) {

    }

    protected void ASPxScheduler1_BeforeExecuteCallbackCommand(object sender, DevExpress.Web.ASPxScheduler.SchedulerCallbackCommandEventArgs e) {
        if (e.CommandId == "CRTAPT")
            e.Command = new CreateAppointmentCallbackCommand((ASPxScheduler)sender);
    }

    protected void SchedulingDataSource_Inserted(object sender, SqlDataSourceStatusEventArgs e) {
        SqlConnection connection = (SqlConnection)e.Command.Connection;
        using (SqlCommand cmd = new SqlCommand("SELECT IDENT_CURRENT('Appointments')", connection)) {
            this.lastInsertedAppointmentId = Convert.ToInt32(cmd.ExecuteScalar());
        }
    }

    protected void Scheduler_AppointmentRowInserting(object sender, ASPxSchedulerDataInsertingEventArgs e) {
        e.NewValues.Remove("ID");
    }

    protected void Scheduler_AppointmentRowInserted(object sender, ASPxSchedulerDataInsertedEventArgs e) {
        e.KeyFieldValue = this.lastInsertedAppointmentId;
    }

    protected void Scheduler_AppointmentsInserted(object sender, PersistentObjectsEventArgs e) {
        ((ASPxSchedulerStorage)sender).SetAppointmentId((Appointment)e.Objects[0], lastInsertedAppointmentId);
    }
}

public class CreateAppointmentCallbackCommand : SchedulerCallbackCommand {
    public override string Id { get { return "CRTAPT"; } }

    private DateTime start;
    protected DateTime Start { get { return start; } set { start = value; } }

    public CreateAppointmentCallbackCommand(ASPxScheduler control)
        : base(control) {

    }

    protected override void ParseParameters(string parameters) {
        //base.ParseParameters(parameters);

        Start = DateTime.Parse(parameters);
    }

    protected override void ExecuteCore() {
        //base.ExecuteCore();

        CreateAppointment();
    }

    protected void CreateAppointment() {
        ASPxGridView grid = (ASPxGridView)this.Control.Page.FindControl("ASPxGridView1");
        ASPxHiddenField hf = (ASPxHiddenField)this.Control.Page.FindControl("hf");
        object[] rowValues = (object[])grid.GetRowValues(Convert.ToInt32(hf["row"]), new string[] { "Name", "TypeName" });

        Appointment apt = this.Control.Storage.CreateAppointment(AppointmentType.Normal);

        apt.Subject = String.Format("{1} - {0}", rowValues[0], rowValues[1]);
        apt.Start = Start;
        apt.End = Start.AddHours(0.5);
        apt.ResourceId = Convert.ToInt32(hf["res"]);

        this.Control.Storage.Appointments.Add(apt);

        this.Control.ActiveView.SelectAppointment(apt);

        ShowAppointmentFormByServerIdCallbackCommand showAppointmentFormByServerIdCallbackCommand = new ShowAppointmentFormByServerIdCallbackCommand(this.Control);

        showAppointmentFormByServerIdCallbackCommand.Execute(AppointmentIdHelper.GetAppointmentId(apt).ToString());
    }
}