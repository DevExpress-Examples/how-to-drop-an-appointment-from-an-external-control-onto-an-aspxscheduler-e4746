using DevExpress.Web;
using DevExpress.Web.ASPxScheduler;
using DevExpress.XtraScheduler;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class _Default : System.Web.UI.Page
{
    protected void Page_Init(object sender, EventArgs e)
    {
        ASPxGridView1.DataSource = MySimpleStandardAppointment.GenerateDS();
        ASPxGridView1.DataBind();
        ASPxScheduler1.Start = DateTime.Today;
        ASPxScheduler1.Storage.Appointments.Labels.Clear();
        ASPxScheduler1.Storage.Appointments.Labels.Add("Green", "GreenName", "MenuCaptionGreen", System.Drawing.Color.Green);
        ASPxScheduler1.Storage.Appointments.Labels.Add("Red", "RedName", "MenuCaptionRed", System.Drawing.Color.Red);

        ASPxScheduler1.Storage.Appointments.Statuses.Clear();
        ASPxScheduler1.Storage.Appointments.Statuses.Add("Delayed", AppointmentStatusType.Custom, "Delayed", "MenuCaptionDelayed", System.Drawing.Color.Yellow);
        ASPxScheduler1.Storage.Appointments.Statuses.Add("Answered", AppointmentStatusType.Custom, "Answered", "MenuCaptionAnswered", System.Drawing.Color.Blue);
    }

    protected void ASPxGridView1_HtmlRowPrepared(object sender, DevExpress.Web.ASPxGridViewTableRowEventArgs e)
    {
        if (e.RowType == GridViewRowType.Data)
        {
            e.Row.Attributes.Add("appTitle", e.GetValue("Title").ToString());
            e.Row.Attributes.Add("appLabel", e.GetValue("Label").ToString());
            e.Row.Attributes.Add("appStatus", e.GetValue("Status").ToString());
            e.Row.Attributes.Add("appDuration", e.GetValue("DurationInHours").ToString());
        }
    }

    protected void ASPxScheduler1_HtmlTimeCellPrepared(object handler, DevExpress.Web.ASPxScheduler.ASPxSchedulerTimeCellPreparedEventArgs e)
    {
        if (e.View.Type != SchedulerViewType.Day) return;
        e.Cell.CssClass += " myDroppableClass";
        e.Cell.Attributes.Add("intResource", e.Resource.Id.ToString());
        e.Cell.Attributes.Add("intStart", e.Interval.Start.ToString());
    }

    protected void ASPxScheduler1_CustomCallback(object sender, CallbackEventArgsBase e)
    {
        var scheduler = (ASPxScheduler)sender;
        string[] parameters = e.Parameter.Split('|');
        Appointment newApp = scheduler.Storage.Appointments.CreateAppointment(AppointmentType.Normal);
        newApp.Subject = parameters[0];
        newApp.ResourceId = parameters[1];
        newApp.StatusKey = parameters[2];
        newApp.LabelKey = parameters[3];
        newApp.Start = DateTime.Parse(parameters[4]);
        newApp.End = DateTime.Parse(parameters[4]).AddHours(Convert.ToInt32(parameters[5]));
        scheduler.Storage.Appointments.Add(newApp);
        scheduler.ActiveView.SelectAppointment(newApp);
        scheduler.Storage.RefreshData();
    }
}