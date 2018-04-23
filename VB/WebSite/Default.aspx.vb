Imports Microsoft.VisualBasic
Imports System
Imports System.Web.UI.WebControls
Imports System.Data.SqlClient
Imports DevExpress.Web.ASPxScheduler
Imports DevExpress.XtraScheduler
Imports DevExpress.Web.ASPxScheduler.Internal
Imports DevExpress.Web.ASPxGridView
Imports DevExpress.Web.ASPxHiddenField

Partial Public Class _Default
	Inherits System.Web.UI.Page
	Private lastInsertedAppointmentId As Integer

	Private Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)

	End Sub

	Protected Sub ASPxScheduler1_BeforeExecuteCallbackCommand(ByVal sender As Object, ByVal e As DevExpress.Web.ASPxScheduler.SchedulerCallbackCommandEventArgs)
		If e.CommandId = "CRTAPT" Then
			e.Command = New CreateAppointmentCallbackCommand(CType(sender, ASPxScheduler))
		End If
	End Sub

	Protected Sub SchedulingDataSource_Inserted(ByVal sender As Object, ByVal e As SqlDataSourceStatusEventArgs)
		Dim connection As SqlConnection = CType(e.Command.Connection, SqlConnection)
		Using cmd As New SqlCommand("SELECT IDENT_CURRENT('Appointments')", connection)
			Me.lastInsertedAppointmentId = Convert.ToInt32(cmd.ExecuteScalar())
		End Using
	End Sub

	Protected Sub Scheduler_AppointmentRowInserting(ByVal sender As Object, ByVal e As ASPxSchedulerDataInsertingEventArgs)
		e.NewValues.Remove("ID")
	End Sub

	Protected Sub Scheduler_AppointmentRowInserted(ByVal sender As Object, ByVal e As ASPxSchedulerDataInsertedEventArgs)
		e.KeyFieldValue = Me.lastInsertedAppointmentId
	End Sub

	Protected Sub Scheduler_AppointmentsInserted(ByVal sender As Object, ByVal e As PersistentObjectsEventArgs)
		CType(sender, ASPxSchedulerStorage).SetAppointmentId(CType(e.Objects(0), Appointment), lastInsertedAppointmentId)
	End Sub
End Class

Public Class CreateAppointmentCallbackCommand
	Inherits SchedulerCallbackCommand
	Public Overrides ReadOnly Property Id() As String
		Get
			Return "CRTAPT"
		End Get
	End Property

	Private start_Renamed As DateTime
	Protected Property Start() As DateTime
		Get
			Return start_Renamed
		End Get
		Set(ByVal value As DateTime)
			start_Renamed = value
		End Set
	End Property

	Public Sub New(ByVal control As ASPxScheduler)
		MyBase.New(control)

	End Sub

	Protected Overrides Sub ParseParameters(ByVal parameters As String)
		'base.ParseParameters(parameters);

		Start = DateTime.Parse(parameters)
	End Sub

	Protected Overrides Sub ExecuteCore()
		'base.ExecuteCore();

		CreateAppointment()
	End Sub

	Protected Sub CreateAppointment()
		Dim grid As ASPxGridView = CType(Me.Control.Page.FindControl("ASPxGridView1"), ASPxGridView)
		Dim hf As ASPxHiddenField = CType(Me.Control.Page.FindControl("hf"), ASPxHiddenField)
		Dim rowValues() As Object = CType(grid.GetRowValues(Convert.ToInt32(hf("row")), New String() { "Name", "TypeName" }), Object())

		Dim apt As Appointment = Me.Control.Storage.CreateAppointment(AppointmentType.Normal)

		apt.Subject = String.Format("{1} - {0}", rowValues(0), rowValues(1))
		apt.Start = Start
		apt.End = Start.AddHours(0.5)
		apt.ResourceId = Convert.ToInt32(hf("res"))

		Me.Control.Storage.Appointments.Add(apt)

		Me.Control.ActiveView.SelectAppointment(apt)

		Dim showAppointmentFormByServerIdCallbackCommand As New ShowAppointmentFormByServerIdCallbackCommand(Me.Control)

		showAppointmentFormByServerIdCallbackCommand.Execute(AppointmentIdHelper.GetAppointmentId(apt).ToString())
	End Sub
End Class