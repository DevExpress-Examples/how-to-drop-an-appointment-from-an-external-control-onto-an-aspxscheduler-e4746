<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="WebApplication1.Default" %>

<%@ Register Assembly="DevExpress.Web.v15.1, Version=15.1.10.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<%@ Register Assembly="DevExpress.Web.ASPxScheduler.v15.1, Version=15.1.10.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxScheduler" TagPrefix="dxwschs" %>
<%@ Register Assembly="DevExpress.XtraScheduler.v15.1.Core, Version=15.1.10.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.XtraScheduler" TagPrefix="cc1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="http://code.jquery.com/jquery-1.10.1.min.js"></script>
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.11.1/jquery-ui.min.js"></script>


    <script type="text/javascript">
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
                        scheduler.RaiseCallback('CRTAPT|' + ASPx.DateUtils.GetInvariantDateTimeString(cell.interval.start));
                    }
                    else
                        alert('Drop the dragged item on a specific time cell.');

                    // Additional logic goes here...
                }
            });

            $('.dxscDateCellBody').droppable({
                hoverClass: "cellOver"
            });

            $('.dxscTimeCellBody').droppable({
                hoverClass: "cellOver"
            });

            $('.dxscTimelineCellBody').droppable({
                hoverClass: "cellOver"
            });
        }
    </script>

    <style type="text/css">
        .cellOver
        {
            background-color: lightblue !important;
            border: 2px dotted !important;
        }
        .dropTargetActive
        {
            border: solid 5px red;
        }
        .dropTargetHover
        {
            border: solid 5px yellow;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <table>
                <tr>
                    <td>
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
                                            <input type="hidden" value='<%# Container.VisibleIndex %>' />
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
                            <dxwschs:ASPxScheduler ID="ASPxScheduler1" runat="server" AppointmentDataSourceID="ObjectDataSourceAppointment"
                                ClientIDMode="AutoID" Start='<%#DateTime.Now%>' GroupType="Date" ClientInstanceName="scheduler"
                                ResourceDataSourceID="ObjectDataSourceResources" OnBeforeExecuteCallbackCommand="ASPxScheduler1_BeforeExecuteCallbackCommand">
                                <Storage>
                                    <Appointments AutoRetrieveId="True">
                                        <Mappings
                                            AllDay="AllDay"
                                            AppointmentId="Id"
                                            Description="Description"
                                            End="EndTime"
                                            Label="Label"
                                            Location="Location"
                                            ReminderInfo="ReminderInfo"
                                            ResourceId="OwnerId"
                                            Start="StartTime"
                                            Status="Status"
                                            Subject="Subject"
                                            Type="EventType" />
                                    </Appointments>
                                    <Resources>
                                        <Mappings
                                            Caption="Name"
                                            ResourceId="ResID" />
                                    </Resources>
                                </Storage>

                                <Views>
                                    <DayView>
                                        <TimeRulers>
                                            <cc1:TimeRuler AlwaysShowTimeDesignator="False"></cc1:TimeRuler>
                                        </TimeRulers>
                                        <DayViewStyles ScrollAreaHeight="600px">
                                        </DayViewStyles>
                                    </DayView>

                                    <WorkWeekView>
                                        <TimeRulers>
                                            <cc1:TimeRuler></cc1:TimeRuler>
                                        </TimeRulers>
                                    </WorkWeekView>
                                    <TimelineView>
                                        <CellAutoHeightOptions Mode="FitToContent" />
                                    </TimelineView>

                                    <FullWeekView>
                                        <TimeRulers>
                                            <cc1:TimeRuler></cc1:TimeRuler>
                                        </TimeRulers>
                                    </FullWeekView>
                                </Views>
                            </dxwschs:ASPxScheduler>
                        </div>
                    </td>
                </tr>
            </table>

            <dx:ASPxHiddenField ID="hf" runat="server" ClientInstanceName="hf" SyncWithServer="true">
            </dx:ASPxHiddenField>

            <dx:ASPxGlobalEvents ID="ASPxGlobalEvents1" runat="server">
                <ClientSideEvents ControlsInitialized="InitalizejQuery" EndCallback="InitalizejQuery" />
            </dx:ASPxGlobalEvents>

            <asp:AccessDataSource ID="gridDS" runat="server" DataFile="~/App_Data/GridDB.mdb" SelectCommand="SELECT * FROM [Appointments]"></asp:AccessDataSource>

            <asp:ObjectDataSource ID="ObjectDataSourceResources" runat="server" OnObjectCreated="ObjectDataSourceResources_ObjectCreated" SelectMethod="SelectMethodHandler" TypeName="WebApplication1.CustomResourceDataSource"></asp:ObjectDataSource>
            <asp:ObjectDataSource ID="ObjectDataSourceAppointment" runat="server" DataObjectTypeName="WebApplication1.CustomAppointment" DeleteMethod="DeleteMethodHandler" InsertMethod="InsertMethodHandler" SelectMethod="SelectMethodHandler" TypeName="WebApplication1.CustomAppointmentDataSource" UpdateMethod="UpdateMethodHandler" OnObjectCreated="ObjectDataSourceAppointment_ObjectCreated"></asp:ObjectDataSource>
        </div>
    </form>
</body>
</html>
