<%@ Page Language="vb" AutoEventWireup="true" CodeFile="Default.aspx.vb" Inherits="_Default" %>

<%@ Register Assembly="DevExpress.Web.v17.2, Version=17.2.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<%@ Register Assembly="DevExpress.Web.ASPxScheduler.v17.2, Version=17.2.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxScheduler" TagPrefix="dxwschs" %>

<%@ Register Assembly="DevExpress.XtraScheduler.v17.2.Core, Version=17.2.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.XtraScheduler" TagPrefix="cc1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
    <script type="text/javascript" src="https://code.jquery.com/ui/1.10.4/jquery-ui.min.js"></script>
    <style>
        .activeHover {
            background-color: lightblue !important;
        }

        .ui-draggable-dragging {
            background-color: lightgreen;
            color: White;
        }
    </style>
    <script type="text/javascript">
        function InitalizejQuery() {
            $('.draggable').draggable({
                helper: 'clone',
                start: function (ev, ui) {
                    var $draggingElement = $(ui.helper);
                    $draggingElement.width(gridView.GetWidth());
                }
            });
            $('.myDroppableClass').droppable({
                tolerance: "intersect",
                hoverClass: "activeHover",
                drop: function (event, ui) {
                    var appTitle = ui.draggable.attr("appTitle");
                    var appStatus = ui.draggable.attr("appStatus");
                    var appDuration = ui.draggable.attr("appDuration");
                    var appLabel = ui.draggable.attr("appLabel");
                    var intResource = $(this).attr("intResource");
                    var intStart = $(this).attr("intStart");
                    scheduler.PerformCallback(appTitle + "|" + intResource + "|" + appStatus + "|" + appLabel + "|" + intStart + "|" + appDuration);
                }
            });
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div>

            <dx:ASPxGridView ID="ASPxGridView1" runat="server" AutoGenerateColumns="false" KeyFieldName="Title"
                OnHtmlRowPrepared="ASPxGridView1_HtmlRowPrepared" ClientInstanceName="gridView">
                <Columns>
                    <dx:GridViewDataTextColumn FieldName="Title"></dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="DurationInHours"></dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="Label"></dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="Status"></dx:GridViewDataTextColumn>
                </Columns>
                <Styles>
                    <Row CssClass="draggable"></Row>
                </Styles>
            </dx:ASPxGridView>
            <dxwschs:ASPxScheduler ID="ASPxScheduler1" runat="server" Width="700px" AppointmentDataSourceID="ObjectDataSourceAppointments" ClientInstanceName="scheduler"
                ResourceDataSourceID="ObjectDataSourceResources" GroupType="Resource" OnHtmlTimeCellPrepared="ASPxScheduler1_HtmlTimeCellPrepared"
                OnCustomCallback="ASPxScheduler1_CustomCallback">
                <Storage>
                    <Appointments AutoRetrieveId="true">
                        <Mappings AppointmentId="ID" End="EndDate" Label="Label" ResourceId="ResourceID" Start="StartDate" Status="Status" Subject="Title" RecurrenceInfo="MyRecurrenceInfo" Type="Type" Description="Description" />
                    </Appointments>
                    <Resources>
                        <Mappings Caption="ResourceName" ResourceId="ResourceID" />
                    </Resources>
                </Storage>
                <Views>
                    <DayView>
                        <TimeRulers>
                            <cc1:TimeRuler></cc1:TimeRuler>
                        </TimeRulers>
                        <AppointmentDisplayOptions ColumnPadding-Left="2" ColumnPadding-Right="4"></AppointmentDisplayOptions>
                        <DayViewStyles ScrollAreaHeight="600px"></DayViewStyles>
                    </DayView>
                    <WorkWeekView ViewSelectorItemAdaptivePriority="6">
                        <TimeRulers>
                            <cc1:TimeRuler></cc1:TimeRuler>
                        </TimeRulers>
                        <AppointmentDisplayOptions ColumnPadding-Left="2" ColumnPadding-Right="4"></AppointmentDisplayOptions>
                    </WorkWeekView>
                    <WeekView Enabled="false"></WeekView>
                    <MonthView ViewSelectorItemAdaptivePriority="5"></MonthView>
                    <TimelineView ViewSelectorItemAdaptivePriority="3"></TimelineView>
                    <FullWeekView Enabled="true">
                        <TimeRulers>
                            <cc1:TimeRuler></cc1:TimeRuler>
                        </TimeRulers>
                        <AppointmentDisplayOptions ColumnPadding-Left="2" ColumnPadding-Right="4"></AppointmentDisplayOptions>
                    </FullWeekView>
                    <AgendaView DayHeaderOrientation="Auto" ViewSelectorItemAdaptivePriority="1"></AgendaView>
                </Views>
                <OptionsToolTips AppointmentToolTipCornerType="None"></OptionsToolTips>
            </dxwschs:ASPxScheduler>
            <dx:ASPxGlobalEvents ID="ge" runat="server">
                <ClientSideEvents ControlsInitialized="InitalizejQuery" EndCallback="InitalizejQuery" />
            </dx:ASPxGlobalEvents>
            <asp:ObjectDataSource ID="ObjectDataSourceAppointments" runat="server"
                DataObjectTypeName="MySimpleAppointment" TypeName="MySimpleAppointmentAdapter"
                InsertMethod="Create" UpdateMethod="Update" SelectMethod="Read" DeleteMethod="Delete" />
            <asp:ObjectDataSource ID="ObjectDataSourceResources" runat="server"
                DataObjectTypeName="MySimpleResource" TypeName="MySimpleResourceAdapter"
                SelectMethod="GetDS" />
        </div>
    </form>
</body>
</html>