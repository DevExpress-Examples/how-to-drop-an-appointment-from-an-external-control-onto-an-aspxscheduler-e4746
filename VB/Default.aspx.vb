Option Infer On

Imports DevExpress.Web
Imports DevExpress.Web.ASPxScheduler
Imports DevExpress.XtraScheduler
Imports System
Imports System.Collections.Generic
Imports System.Linq
Imports System.Web
Imports System.Web.UI
Imports System.Web.UI.WebControls

Partial Public Class _Default
    Inherits System.Web.UI.Page

    Protected Sub Page_Init(ByVal sender As Object, ByVal e As EventArgs)
        ASPxGridView1.DataSource = MySimpleStandardAppointment.GenerateDS()
        ASPxGridView1.DataBind()
        ASPxScheduler1.Start = Date.Today
        ASPxScheduler1.Storage.Appointments.Labels.Clear()
        ASPxScheduler1.Storage.Appointments.Labels.Add("Green", "GreenName", "MenuCaptionGreen", System.Drawing.Color.Green)
        ASPxScheduler1.Storage.Appointments.Labels.Add("Red", "RedName", "MenuCaptionRed", System.Drawing.Color.Red)

        ASPxScheduler1.Storage.Appointments.Statuses.Clear()
        ASPxScheduler1.Storage.Appointments.Statuses.Add("Delayed", AppointmentStatusType.Custom, "Delayed", "MenuCaptionDelayed", System.Drawing.Color.Yellow)
        ASPxScheduler1.Storage.Appointments.Statuses.Add("Answered", AppointmentStatusType.Custom, "Answered", "MenuCaptionAnswered", System.Drawing.Color.Blue)
    End Sub

    Protected Sub ASPxGridView1_HtmlRowPrepared(ByVal sender As Object, ByVal e As DevExpress.Web.ASPxGridViewTableRowEventArgs)
        If e.RowType = GridViewRowType.Data Then
            e.Row.Attributes.Add("appTitle", e.GetValue("Title").ToString())
            e.Row.Attributes.Add("appLabel", e.GetValue("Label").ToString())
            e.Row.Attributes.Add("appStatus", e.GetValue("Status").ToString())
            e.Row.Attributes.Add("appDuration", e.GetValue("DurationInHours").ToString())
        End If
    End Sub

    Protected Sub ASPxScheduler1_HtmlTimeCellPrepared(ByVal handler As Object, ByVal e As DevExpress.Web.ASPxScheduler.ASPxSchedulerTimeCellPreparedEventArgs)
        If e.View.Type <> SchedulerViewType.Day Then
            Return
        End If
        e.Cell.CssClass &= " myDroppableClass"
        e.Cell.Attributes.Add("intResource", e.Resource.Id.ToString())
        e.Cell.Attributes.Add("intStart", e.Interval.Start.ToString())
    End Sub

    Protected Sub ASPxScheduler1_CustomCallback(ByVal sender As Object, ByVal e As CallbackEventArgsBase)
        Dim scheduler = DirectCast(sender, ASPxScheduler)
        Dim parameters() As String = e.Parameter.Split("|"c)
        Dim newApp As Appointment = scheduler.Storage.Appointments.CreateAppointment(AppointmentType.Normal)
        newApp.Subject = parameters(0)
        newApp.ResourceId = parameters(1)
        newApp.StatusKey = parameters(2)
        newApp.LabelKey = parameters(3)
        newApp.Start = Date.Parse(parameters(4))
        newApp.End = Date.Parse(parameters(4)).AddHours(Convert.ToInt32(parameters(5)))
        scheduler.Storage.Appointments.Add(newApp)
        scheduler.ActiveView.SelectAppointment(newApp)
        scheduler.Storage.RefreshData()
    End Sub
End Class