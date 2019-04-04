<!-- default file list -->
*Files to look at*:

* [Default.aspx](./CS/WebApplication1/Default.aspx) (VB: [Default.aspx](./VB/WebApplication1/Default.aspx))
* [Default.aspx.cs](./CS/WebApplication1/Default.aspx.cs) (VB: [Default.aspx.vb](./VB/WebApplication1/Default.aspx.vb))
<!-- default file list end -->
# How to drop an appointment from an external control onto an ASPxScheduler


<p>This example illustrates how to drag and drop an item from an external control (<a href="http://documentation.devexpress.com/#AspNet/clsDevExpressWebASPxGridViewASPxGridViewtopic">ASPxGridView</a> in this example) to the ASPxScheduler area in order to create an appointment. Note that this example is an extended version of the <a href="https://www.devexpress.com/Support/Center/p/E4292">ASPxScheduler - How to drag a row from ASPxGridView and create an appointment based on its values</a> code example. The advantage of this project is that an appointment is created in a time cell to which a corresponding grid item is dropped, whereas in the previous example, the appointment time is taken from a grid row. <br><br>Here is a screenshot that illustrates a sample application in action during the custom drag-and-drop operation:<br><img src="https://raw.githubusercontent.com/DevExpress-Examples/how-to-drop-an-appointment-from-an-external-control-onto-an-aspxscheduler-e4746/15.1.3+/media/885f5764-10c4-46ab-be38-7a821ec026c1.png"></p>
<p><br><strong>See Also:</strong></p>
<p><a href="https://www.devexpress.com/Support/Center/p/E4708">How to drop an appointment from ASPxScheduler to an external control</a></p>


<h3>Description</h3>

<p>To obtain the current/active time cell, we use non-documented&nbsp;<strong>CalcHitTest</strong>&nbsp;and&nbsp;<strong>initializeCell</strong>&nbsp;client-side methods. After that we initiate a custom callback to the server (see <a href="http://documentation.devexpress.com/#AspNet/CustomDocument5462">Callback Commands</a>) in order to create an appointment according to the current grid row and scheduler time cell. Note that the grid row Id and the selected resource Id are passed via a hidden field, whereas the current time is passed via the <strong>RaiseCallback </strong>method. This is done only to illustrate different approaches. It is enough to use only one approach (either a hidden field or the <strong>RaiseCallback </strong>method) if necessary.&nbsp;<br><br></p>
<p>We attach <a href="http://jqueryui.com/draggable/">Draggable</a> interaction from jQuery to a DIV within a grid cell template so that the DIV can be dragged. The DIV with the ASPxScheduler inside serves as a drop target. We attach <a href="http://jqueryui.com/droppable/">Droppable</a> interaction to it.</p>
<p>&nbsp;</p>
<p>The <strong>InitalizejQuery</strong> method is called from the client-side <strong>ControlsInitialized </strong>and <strong>EndCallback </strong>event handlers of the <a href="http://documentation.devexpress.com/#AspNet/clsDevExpressWebASPxGlobalEventsASPxGlobalEventstopic">ASPxGlobalEvents Class</a>. It is a recommended technique to perform jQuery-related actions with our controls (see <a data-ticket="E3325">ASPxTextBox - How to attach the jQuery AutoComplete plugin</a>).&nbsp;<br><br>Here is implementation of the&nbsp;&nbsp;<strong>InitalizejQuery</strong>&nbsp;method:&nbsp;</p>
<code lang="js">        function InitalizejQuery(s, e) {
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
        }</code>
<p>&nbsp;</p>
<p>As for server-side code, the main work is performed in the <strong>CreateAppointmentCallbackCommand</strong><strong>.</strong><strong>CreateAppointment()</strong> method. We parse passed parameters in this method and create an appointment. Finally, we add the code to automatically invoke an appointment form as shown in the <a data-ticket="E3043">How to create an appointment and display it in the editing form automatically</a> code example.</p>

<br/>


