<%@ Page Language="vb" AutoEventWireup="true" CodeFile="Default.aspx.vb" Inherits="_Default" %>

<%@ Register tagPrefix="dx" namespace="DevExpress.Web.ASPxGlobalEvents" assembly="DevExpress.Web.v12.2, Version=12.2.10.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" %>
<%@ Register tagPrefix="dx" namespace="DevExpress.Web.ASPxHiddenField" assembly="DevExpress.Web.v12.2, Version=12.2.10.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" %>
<%@ Register tagPrefix="dx" namespace="DevExpress.Web.ASPxScheduler" assembly="DevExpress.Web.ASPxScheduler.v12.2, Version=12.2.10.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" %>
<%@ Register tagPrefix="dx" namespace="DevExpress.Web.ASPxGridView" assembly="DevExpress.Web.v12.2, Version=12.2.10.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
	<title>Page</title>
	<script type="text/javascript" src="scripts/jquery-1.8.0.min.js"></script>
	<script type="text/javascript" src="scripts/jquery-ui-1.8.23.custom.min.js"></script>

	<script type="text/javascript" language="javascript">
		function InitalizejQuery(s, e) {
			$('.draggable').draggable({ helper: 'clone', appendTo: 'body', zIndex: 100 });
			$('.droppable').droppable({
					activeClass: "dropTargetActive",
					hoverClass: "dropTargetHover",

					drop: function (ev, ui) {
						// Make a clone of the dragged item
						var clone = (ui.draggable).clone();

						// Get a row index:
						row = $(clone).find("input[type='hidden']").val();
						hf.Set('row', row);

						// Calculate an active time cell
						var cell = scheduler.CalcHitTest(ev).cell;    

						// Initiate a scheduler callback to create an appointment based on a cell interval
						if (cell != null) {
							scheduler.InitializeCell(cell);
							hf.Set('res', cell.resource);
							scheduler.RaiseCallback('CRTAPT|' + _aspxGetInvariantDateTimeString(cell.interval.start));
						}
						else
							alert('Drop the dragged item on a specific time cell.');

						// Additional logic goes here...
					}
				}
			 );
		}
	</script>

	<style type="text/css">
		.dropTargetActive {
			border: solid 5px red;
		}
		.dropTargetHover {
			border: solid 5px yellow;
		}
	</style>
</head>
<body>
	<form id="form1" runat="server">
	<div>
		<table>
			<tr>
				<td style="vertical-align: top">
					<dx:ASPxGridView ID="ASPxGridView1" runat="server" DataSourceID="gridDS" AutoGenerateColumns="False" ClientInstanceName="grid"
						Width="100%" KeyFieldName="ID">
						<Columns>
							<dx:GridViewDataTextColumn FieldName="ID" ReadOnly="True" Visible="False" VisibleIndex="0">
							</dx:GridViewDataTextColumn>
							<dx:GridViewDataTextColumn FieldName="TypeName" VisibleIndex="1">
							</dx:GridViewDataTextColumn>
							<dx:GridViewDataTextColumn FieldName="Name" VisibleIndex="2">
							</dx:GridViewDataTextColumn>
							<dx:GridViewDataDateColumn FieldName="Date" VisibleIndex="3">
							</dx:GridViewDataDateColumn>
							<dx:GridViewDataHyperLinkColumn Caption="Image" ReadOnly="True">
								<Settings AllowSort="False"></Settings>
								<EditFormSettings Visible="False" />
								<DataItemTemplate>
									<div class="draggable">
										<a href="#" title="Image Viewer">
											<img src="Images/drag.jpg" alt="" />
										</a>
										<input type="hidden" value='<%#Container.VisibleIndex%>' />
									</div>
								</DataItemTemplate>
							</dx:GridViewDataHyperLinkColumn>
							<dx:GridViewDataTextColumn FieldName="TypeID" Visible="false">
							</dx:GridViewDataTextColumn>
						</Columns>
					</dx:ASPxGridView>
				</td>
			</tr>
			<tr>
				<td>
					<div class="droppable">
						<dx:ASPxScheduler runat="server" ID="Scheduler" ClientInstanceName="scheduler" GroupType="Resource"
							AppointmentDataSourceID="AppointmentDataSource" ResourceDataSourceID="ResourceDataSource" 
							Start="2011-04-06" OnAppointmentRowInserting="Scheduler_AppointmentRowInserting"
							OnAppointmentRowInserted="Scheduler_AppointmentRowInserted" OnAppointmentsInserted="Scheduler_AppointmentsInserted"
							onbeforeexecutecallbackcommand="ASPxScheduler1_BeforeExecuteCallbackCommand">
							<Views>
								<WorkWeekView ShowFullWeek="true" />
							</Views>
							<Storage EnableReminders="False">
								<Appointments>
									<Mappings AppointmentId="ID" Type="EventType" Start="StartDate" End="EndDate" AllDay="AllDay"
										Subject="Subject" Location="Location" Description="Description" Status="Status"
										Label="Label" ResourceId="ResourceID" RecurrenceInfo="RecurrenceInfo" />
								</Appointments>
								<Resources>
									<Mappings ResourceId="ID" Caption="Name" />
								</Resources>
							</Storage>
							<OptionsBehavior RecurrentAppointmentEditAction="Ask" />
							<BorderLeft BorderWidth="0" />
						</dx:ASPxScheduler>
					</div>
				</td>
			</tr>
		</table>

		<dx:ASPxHiddenField ID="hf" runat="server" ClientInstanceName="hf" SyncWithServer="true">
		</dx:ASPxHiddenField>

		<dx:ASPxGlobalEvents ID="ASPxGlobalEvents1" runat="server">
			<ClientSideEvents ControlsInitialized="InitalizejQuery" EndCallback="InitalizejQuery" />
		</dx:ASPxGlobalEvents>

		<asp:AccessDataSource ID="gridDS" runat="server" DataFile="~/App_Data/GridDB.mdb"
			SelectCommand="SELECT * FROM [Appointments]"></asp:AccessDataSource>

		<asp:SqlDataSource ID="AppointmentDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:DataConnectionString %>"
			DeleteCommand="DELETE FROM [Appointments] WHERE [ID] = @ID" InsertCommand="INSERT INTO [Appointments] ([EventType], [StartDate], [EndDate], [AllDay], [Subject], [Location], [Description], [Status], [Label], [ResourceID], [RecurrenceInfo], [ReminderInfo], [ContactInfo]) VALUES (@EventType, @StartDate, @EndDate, @AllDay, @Subject, @Location, @Description, @Status, @Label, @ResourceID, @RecurrenceInfo, @ReminderInfo, @ContactInfo)"
			ProviderName="System.Data.SqlClient" SelectCommand="SELECT * FROM [Appointments]"
			UpdateCommand="UPDATE [Appointments] SET [EventType] = @EventType, [StartDate] = @StartDate, [EndDate] = @EndDate, [AllDay] = @AllDay, [Subject] = @Subject, [Location] = @Location, [Description] = @Description, [Status] = @Status, [Label] = @Label, [ResourceID] = @ResourceID, [RecurrenceInfo] = @RecurrenceInfo, [ReminderInfo] = @ReminderInfo, [ContactInfo] = @ContactInfo WHERE [ID] = @ID"
			OnInserted="SchedulingDataSource_Inserted">
			<DeleteParameters>
				<asp:Parameter Name="ID" Type="Int32" />
			</DeleteParameters>
			<InsertParameters>
				<asp:Parameter Name="EventType" Type="Int32" />
				<asp:Parameter Name="StartDate" Type="DateTime" />
				<asp:Parameter Name="EndDate" Type="DateTime" />
				<asp:Parameter Name="AllDay" Type="Boolean" />
				<asp:Parameter Name="Subject" Type="String" />
				<asp:Parameter Name="Location" Type="String" />
				<asp:Parameter Name="Description" Type="String" />
				<asp:Parameter Name="Status" Type="Int32" />
				<asp:Parameter Name="Label" Type="Int32" />
				<asp:Parameter Name="ResourceID" Type="Int32" />
				<asp:Parameter Name="RecurrenceInfo" Type="String" />
				<asp:Parameter Name="ReminderInfo" Type="String" />
				<asp:Parameter Name="ContactInfo" Type="String" />
			</InsertParameters>
			<UpdateParameters>
				<asp:Parameter Name="EventType" Type="Int32" />
				<asp:Parameter Name="StartDate" Type="DateTime" />
				<asp:Parameter Name="EndDate" Type="DateTime" />
				<asp:Parameter Name="AllDay" Type="Boolean" />
				<asp:Parameter Name="Subject" Type="String" />
				<asp:Parameter Name="Location" Type="String" />
				<asp:Parameter Name="Description" Type="String" />
				<asp:Parameter Name="Status" Type="Int32" />
				<asp:Parameter Name="Label" Type="Int32" />
				<asp:Parameter Name="ResourceID" Type="Int32" />
				<asp:Parameter Name="RecurrenceInfo" Type="String" />
				<asp:Parameter Name="ReminderInfo" Type="String" />
				<asp:Parameter Name="ContactInfo" Type="String" />
				<asp:Parameter Name="ID" Type="Int32" />
			</UpdateParameters>
		</asp:SqlDataSource>

		<asp:SqlDataSource ID="ResourceDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:DataConnectionString %>"
			ProviderName="System.Data.SqlClient" SelectCommand="SELECT * FROM [Resources]">
		</asp:SqlDataSource>
	</div>
	</form>
</body>
</html>