<%@  language="VBSCRIPT" %>
<%

 '********************************************************************
 ' Name: scOutstanding.asp
 '
 ' Purpose: Show the calls that are outstanding and waiting for
 '			a schedule time
 '
 ' Input:
 ' Output:
 '
 '********************************************************************

 Option Explicit
 Response.Expires = 0


 '********************************************************************
 ' Include Files
 '********************************************************************

%>
<!--#includes file="includes/session.asp"-->
<!--#includes file="includes/utils.asp"-->
<!--#includes file="includes/oledb.asp"-->
<%

 '********************************************************************
 ' Global Variables
 '********************************************************************

 Const PAGE_NAME = "Scheduler"

 '********************************************************************
 ' Main
 '********************************************************************
 Main

 '--------------------------------------------------------------------
 ' Function: Main
 '
 ' Purpose: Entry point for the page.
 '--------------------------------------------------------------------
 Sub Main

	Dim objConn, rsService, strColor, strBgColor, rsColor, i, queryString, rsCategories, strResponseAbsoluteTime, sql

%>
<!DOCTYPE HTML>
<html>
<head>
    <title>
        <%= PAGE_NAME %> </title>
    <meta content="text/html; charset=windows-1252" http-equiv="Content-Type">
    <link rel="StyleSheet" href="stylesheets/general.css">
    <link href="stylesheets/custom-theme/jquery-ui-1.8.19.custom.css" rel="stylesheet"
        type="text/css" />
    <!--    <script type="text/javascript" src="js/jquery-1.8.2.min.js"></script>

    <script src="js/jquery-ui-1.9.1.custom.min.js" type="text/javascript"></script>-->
    <!---->
 
   
    
</head>
<%
BeginPage PAGE_NAME
Set objConn = New Connection
%>
<!--  Main  -->
 <style type="text/css">
        .ui-timepicker-div .ui-widget-header
        {
            margin-bottom: 8px;
        }
        .ui-timepicker-div dl
        {
            text-align: left;
        }
        .ui-timepicker-div dl dt
        {
            height: 25px;
            margin-bottom: -25px;
        }
        .ui-timepicker-div dl dd
        {
            margin: 0 10px 10px 65px;
        }
        .ui-timepicker-div td
        {
            font-size: 90%;
        }
        .ui-tpicker-grid-label
        {
            background: none;
            border: none;
            margin: 0;
            padding: 0;
        }
        .ui-timepicker-rtl
        {
            direction: rtl;
        }
        .ui-timepicker-rtl dl
        {
            text-align: right;
        }
        .ui-timepicker-rtl dl dd
        {
            margin: 0 65px 10px 10px;
        }
        #Text2
        {
            width: 701px;
        }
    </style>
    
    <script type="text/javascript">
        $(document).ready(function() {
            if (MJSystem != "ServiceDesk") {
                $('.cboAssignCls').change(function() {
                    var serviceCode = $(this).attr('serviceCode');
                    var assignTo = $(this).val()
                    
                    window.location = 'scOutstanding.asp?<%=Request.ServerVariables("QUERY_STRING") %>&hidServiceCode=' + serviceCode + '&assignTo=' + assignTo;
                });
            }

            $('.btnService').click(function() {
                var serviceCode = $(this).attr('serviceCode');
                if (confirm('Are you sure you want to assign this Call to Service Desk?'))
                    window.location = 'scOutstanding.asp?<%=Request.ServerVariables("QUERY_STRING") %>&hidServiceCode=' + serviceCode + '&serviceDesk=1';
            });

            $('.btnAssignTier').click(function() {
                var serviceCode = $(this).attr('serviceCode');
                if (confirm('Are you sure you want to assign this Call to Tier 2?'))
                    window.location = 'scOutstanding.asp?<%=Request.ServerVariables("QUERY_STRING") %>&hidServiceCode=' + serviceCode + '&assignTier=2';
            });

            $('.btnAssignTier1').click(function() {
                var serviceCode = $(this).attr('serviceCode');
                if (confirm('Are you sure you want to assign this Call to Tier 1?'))
                    window.location = 'scOutstanding.asp?<%=Request.ServerVariables("QUERY_STRING") %>&hidServiceCode=' + serviceCode + '&assignTier=1';
            });

            $('.cboMoveToCls').change(function() {
                var serviceCode = $(this).attr('serviceCode');
                var moveTo = $(this).val()
                window.location = 'scOutstanding.asp?<%=Request.ServerVariables("QUERY_STRING") %>&hidServiceCode=' + serviceCode + '&moveTo=' + moveTo;
            });

            $('.btnAssign').click(function() {

                var serviceCode = $(this).attr('serviceCode');
                var technician = $('.cboAssignCls[serviceCode=' + serviceCode + ']').val();

                if (technician == "-1") {
                    alert("Please select a technician.");
                    return;
                }

                var scheduleTime = $('.scheduleTime[serviceCode=' + serviceCode + ']').val();
                //alert(scheduleTime);

                //
                var estDay = parseInt($('.estDay[serviceCode=' + serviceCode + ']').val());

                var estHour = parseInt($('.estHour[serviceCode=' + serviceCode + ']').val());

                var estMinute = parseInt($('.estMinute[serviceCode=' + serviceCode + ']').val());

                if (isNaN(estDay) || isNaN(estHour) || isNaN(estMinute)) {
                    alert("Please enter correct estimation time.");
                    return;
                }

                var estDuration = estMinute + estHour * 60 + estDay * 24 * 60;

                //var moveTo = $(this).val()
                window.location = 'scOutstanding.asp?<%=Request.ServerVariables("QUERY_STRING") %>&hidServiceCode=' + serviceCode + '&scheduleTime=' + escape(scheduleTime)
            + "&estDuration=" + estDuration + "&technician=" + technician
            });

        });
</script>

<script src="js/openWindow.js" type="text/javascript"></script>

<script src="js/jquery-ui-timepicker-addon.js" type="text/javascript"></script>

<script type="text/javascript">

    $(document).ready(function() {
        $('.datetimepicker').datetimepicker({
            dateFormat: "dd/mm/yy ",
            stepMinute: 5
        });
        $('.datetimepicker').datetimepicker('setDate', (new Date()));
        $('.btnAssign').button();
        $('.btnAssignTier').button();
        $('.btnAssignTier1').button();
        $('.btnService').button();
    });
</script>

   <script type="text/javascript">
       $(function() {
           //$(document).tooltip();
       });
    </script>

<% if  (Session("MJSystem") <> "O2ESS") or  (DbGroupId >= ALPHA_DISPATCHERS) then%>

<table border="0" width="900" cellspacing="4" cellpadding="3">
    <%
	  Dim rsDisputedCalls

	  Set rsDisputedCalls = objConn.Query("select D.SessionID, convert(varchar(17), D.DisputedTime, 113) as CDisputedTime, S.ServiceCode, D.Reason from Disputed D, Session S where D.SessionID=S.SessionID and DateDiff(dd, DisputedTime, GETDATE())<=15 order by DisputedTime desc")
	  If false and not rsDisputedCalls.EOF Then

    %>
    <tr>
        <td>
            Disputed calls:<br>
            <br>
            <table width="100%" style="border: 1px solid #666666">
                <tr>
                    <td align="center" bgcolor="#D0D0D0">
                        <font face="Verdana" size="1">Service</font>
                    </td>
                    <td align="center" bgcolor="#D0D0D0">
                        <font face="Verdana" size="1">Session</font>
                    </td>
                    <td bgcolor="#D0D0D0">
                        <font face="Verdana" size="1">Reason</font>
                    </td>
                    <td bgcolor="#D0D0D0">
                        <font face="Verdana" size="1">Diputed On</font>
                    </td>
                </tr>
                <%
		While not rsDisputedCalls.EOF
                %>
                <tr>
                    <td align="center">
                        <a href="rcForm.asp?ServiceCode=<%=rsDisputedCalls("ServiceCode")%>"><font face="Verdana"
                            size="1" color="#DD0000">
                            <%=rsDisputedCalls("ServiceCode")%></font></a>
                    </td>
                    <td align="center">
                        <font face="Verdana" size="1" color="#DD0000">
                            <%=rsDisputedCalls("SessionID")%></font>
                    </td>
                    <td>
                        <font face="Verdana" size="1" color="#DD0000">
                            <%
				If Len(rsDisputedCalls("Reason"))<35 Then
					Response.Write rsDisputedCalls("Reason")
				Else
					Response.Write Left(rsDisputedCalls("Reason"),34)&"..."
				End If
                            %></font>
                    </td>
                    <td>
                        <font face="Verdana" size="1" color="#DD0000">
                            <%=rsDisputedCalls("CDisputedTime")%></font>
                    </td>
                </tr>
                <%
			rsDisputedCalls.MoveNext
		Wend
                %>
            </table>
        </td>
    </tr>
    <%
	  End If
    %>
    <tr>
        <td valign="top">
            <%
        Dim intCategory
        intCategory = -1
        If Request("cboCategory") <> "" Then
        	intCategory = CLng(Request("cboCategory"))
        End If
            %>
            <% 
        Const adLockBatchOptimistic = 4
        Const adUseClient = 3 
        
        
        
        
        
        'set rsTechnicians = rsConnTechnicians.GetRows
        'rsTechnicians.Close
        'Response.Write(sql)
		'Set rsTechnicians = objconn.Query(sql)
		
            %>
            <%
		    dim technician, day, location, client, serviceCategory
		    technician = "-1"
		    day = "-1"
		    location = "-1"
		    client = "-1"
		    serviceCategory = "-1"

		    
		    if Request("cboTechnician") <> "" then
		        technician = Request("cboTechnician")
		    end if
		    if Request("cboDay") <> "" then
		        day = Request("cboDay")
		    end if
		    if Request("cboLocation") <> "" then
		        location = Request("cboLocation")
		    end if
		    if Request("cboClient") <> "" then
		        client = Request("cboClient")
		    end if
		    if Request("cboType") <> "" then
		        serviceCategory = Request("cboType")
		    end if
		    if Request("moveTo") <> "" then
		    sql = "UPDATE Service SET CallCategoryID= " &_
                    "(SELECT CallCategoryID FROM CallCategory WHERE CallCategoryID='" & Request("moveTo") & "') " &_
                    "WHERE ServiceCode=" & Request("hidServiceCode")
                    response.Write(sql)
                    objConn.Query(sql)
                        Response.Redirect("scOutstanding.asp?cboType="& Request("cboType") & "&cboDay=" & Request("cboDay") & "&cboLocation=" &_
                        Request("cboLocation") & "&cboClient=" & Request("cboClient"))
		        'Response.Redirect("scOutstanding.asp?" & Replace(Request.ServerVariables("QUERY_STRING"),"moveTo","mt"))
		    end if
		    if Request("serviceDesk") <> "" then
		    sql = "UPDATE Service SET SystemType='ServiceDesk' " &_
                  "WHERE ServiceCode=" & Request("hidServiceCode")
                    response.Write(sql)
                    objConn.Query(sql)
                        Response.Redirect("scOutstanding.asp?cboType="& Request("cboType") & "&cboDay=" & Request("cboDay") & "&cboLocation=" &_
                        Request("cboLocation") & "&cboClient=" & Request("cboClient"))
		        
		    end if
		    if Request("assignTo") <> "" then
		        sql = "EXEC AssignCall " & Request("hidServiceCode") & ", '" & Request("assignTo") &"'"
		        objConn.Query(sql)
		        Response.Redirect("scOutstanding.asp?cboType="& Request("cboType") & "&cboDay=" & Request("cboDay") & "&cboLocation=" &_
                        Request("cboLocation") & "&cboClient=" & Request("cboClient"))
		    end if
		    if Request("assignTier") <> "" then
		        sql = "EXEC AssignTier " & Request("hidServiceCode") & "," & Request("assignTier")
		        objConn.Query(sql)
		        Response.Redirect("scOutstanding.asp?cboType="& Request("cboType") & "&cboDay=" & Request("cboDay") & "&cboLocation=" &_
                        Request("cboLocation") & "&cboClient=" & Request("cboClient"))
		    end if
		    if Request("scheduleTime") <> "" then
		        dim arrDate
		        arrDate = split(Request("scheduleTime"),"/")
		        dim strScheduleTime
		        strScheduleTime =  arrDate(1) &"/"& arrDate(0) &"/"& arrDate(2)
		        sql = "EXEC AssignCall " & Request("hidServiceCode") & ", '" & Request("technician") &"','" & strScheduleTime  & "'," & Request("estDuration")
		        objConn.Query(sql)
		        Response.Redirect("scOutstanding.asp?cboType="& Request("cboType") & "&cboDay=" & Request("cboDay") & "&cboLocation=" &_
                        Request("cboLocation") & "&cboClient=" & Request("cboClient"))
		    end if
		    
            %>
            <form action="scOutstanding.asp"  method="GET">
          Choose queue:
            <%dim rsCallCategory
            
            sql = "SELECT * FROM CAllCategory WHERE SystemType = '" & Session("MJSystem") & "' and not((SystemType = 'O2ESS') and (CallCAtegoryNAme = '- All -')) order by CallCategoryName"
            
            Set rsCallCategory = Server.CreateObject("ADODB.Recordset")
        
        rsCallCategory.CursorLocation = adUseClient
        rsCallCategory.LockType = adLockBatchOptimistic
        rsCallCategory.Open sql, objConn.objDbConnectionPublic
        
        Set rsCallCategory.ActiveConnection = Nothing 
        %>
            <select name="cboType" id="cboType">
                <option value="-1">-- All --</option>
                <% While not rsCallCategory.EOF %>
                <option value='<%=rsCallCategory("CallCategoryID") %>' <%if cstr(rsCallCategory("CallCategoryID"))= cstr(Request("cboType")) then response.write("selected=selected") end if  %>>
                    <%= rsCallCategory("CallCategoryName")%></option>
                <% rsCallCategory.MoveNext
                    Wend
              
                %>
              
            </select>
            
           
                        <% Dim rsClient
                            sql = "SELECT DISTINCT c.ClientCode, c.CompanyName FROM Client AS c " &_
                                   "INNER JOIN Service AS v ON v.ClientCode = c.ClientCode " &_
                                   "WHERE v.Status = 'O' " &_
                                   "ORDER By c.CompanyName "
                        '   Response.Write(sql)
		                    Set rsClient = objconn.Query(sql) %>
		                    
              <br></br´><input type="submit" value="   Search   ">
            </form>
            <br>
            <br>
            <%
						'queryString ="EXEC GetOpenCalls " & intCategory & ", 0," & SUserServiceComp
						Dim vec,queryString2

						vec = ""
						
						if (Session("Vec") > 0 ) and (Session("Vec") < 3) then
						    vec = ",'" & Session("VecName") & "'"
						end if
						
						    
						if DbGroupId = ALPHA_GUESTS then
						        queryString ="EXEC GetOpenCalls " & intCategory & ", 0,'-1', '" & serviceCategory & "',-1, '-1', '" & Session("MJSystem") & "',1,0,1,'365'"& vec 
						        queryString2 ="EXEC GetOpenCalls " & intCategory & ", 0,'-1', '" & serviceCategory & "',-1, '-1', '" & Session("MJSystem") & "',0,1,1,'365'" & vec 
						        

						else
						        queryString2 ="EXEC GetOpenCalls " & intCategory & ", 0,'-1', '" & serviceCategory & "',-1, '-1', '" & Session("MJSystem") & "',1,0,0,''" & vec
								queryString ="EXEC GetOpenCalls " & intCategory & ", 0,'-1', '" & serviceCategory & "',-1, '-1', '" & Session("MJSystem") & "',0,1,0,''" & vec
                        
               
						end if
					
                        sql = "SELECT TechnicianCode,Name FROM Technician  WHERE IsDeleted=0 Order by Name"
                        
                        'Response.Write(sql)
                        
                        
		                'Set rsTechnicians = objconn.Query(sql)
						'Response.Write  queryString
						'Response.End
						'Set rsService = objConn.Query(queryString)
						
				    Set rsService = Server.CreateObject("ADODB.Recordset")
        
                    rsService.CursorLocation = adUseClient
                    rsService.LockType = adLockBatchOptimistic
                    rsService.Open queryString, objConn.objDbConnectionPublic
                    
                    Set rsService.ActiveConnection = Nothing 
						
						
						dim callCount 
				    	callCount = 0
						while not rsService.EOF 
						    callCount = callCount + 1
						    rsService.MoveNext
						Wend
						if  callCount > 0 then
						    rsService.MoveFirst
						end if
						
						    
            %>
            <p>
                Call Count: <strong>
                    <%=callCount %></strong>
            </p>
           
            <table style="border: 1px solid #666666" width="840px" cellpadding="0" cellspacing="0">
                <tr>
                    <td>
                        <table width="840px%">
                            <tr>
                                <td bgcolor="#D0D0D0" width="110px">
                                    <font face="Verdana" size="1">Order Time</font>
                                </td>
                                <td bgcolor="#D0D0D0">
                                    <font face="Verdana" size="1" width="100">Company</font>
                                </td>
                                <td bgcolor="#D0D0D0" align="center" width="50">
                                    <font face="Verdana" size="1">Code</font>
                                </td>
                                <td bgcolor="#D0D0D0" align="center">
                                    <font face="Verdana" size="1">Logged By</font>
                                </td>
                                <%if  (Session("MJSystem") <> "O2ESS") then %>
                                <td bgcolor="#D0D0D0">
                                    <font face="Verdana" size="1">Contact</font>
                                </td>
                                <%end if%>
                                <td bgcolor="#D0D0D0" width="110px">
                                    <font face="Verdana" size="1">Last Update</font>
                                </td>
                                <td bgcolor="#D0D0D0" width="260px">
                                    <font face="Verdana" size="1">Description</font>
                                </td>
                                <%If intCategory = 1 Then%>
                                <td bgcolor="#D0D0D0">
                                    <font face="Verdana" size="1">SLA</font>
                                </td>
                                <%End if%>
                                <td bgcolor="#D0D0D0">
                                    <font face="Verdana" size="1">Status</font>
                                </td>
                                <td bgcolor="#D0D0D0">
                                    <font face="Verdana" size="1">Action</font>
                                </td>
                            </tr>
                            <%
						i = 0
						if rsService.EOF then
                            %>
                            <tr>
                                <td colspan="9">
                                    <font face="Verdana" size="1">No outstanding calls.</font>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="9">
                                    <table width="100%" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td bgcolor="#D0D0D0">
                                                <img src="/images/trans.gif" width="20" height="1" border="0">
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <%
						End If%>
						
                            <%While not rsService.EOF %>
                            <form name="frmAssign" id="frmAssign" action="scOutstanding.asp" method="GET">
                            <input type="hidden" name="hidService" id="hidService" value='<%=rsService("ServiceCode")%>' />
                            <input type="hidden" name="hidTech" id="hidTech" value="-1" />
                            <input type="hidden" name="hidReturnUrl" id="hidReturnUrl" value="-1" />
                            <%
							strResponseAbsoluteTime=""
							strColor =""
							strBgColor=""
							
									If DateDiff("n", CDate(rsService("OrderTime")),Now())> (60 * 23) Then
										strColor = " color=""Red"" " 'Red
									ElseIf DateDiff("n", rsService("OrderTime"),Now())> (60*20) Then
										strColor = " color=""Orange"" "  'Orange
									Else
										strColor = " color=""Green"" "  'GreenYellow
									End If
								
							if rsService("Priority") = "H" or rsService("Priority") = "1" or rsService("Priority") = "A" or rsService("Priority") = "B"  then
								strColor= strColor & " ><B"
							else
								strColor = strColor & ""
							end if
                            %>
                            <tr>
                                <td colspan="9" style="border-top: 1px solid #D0D0D0">
                                    <img src="/images/trans.gif" width="1" height="2" border="0">
                                </td>
                            </tr>
                            <TR<%=strBgColor%>>
						    <TD><font face="Verdana" size="1" <%=strColor%>><%=Left(rsService("COrderTime"),Len(rsService("COrderTime"))-3)%></font></TD>
							<TD><font face="Verdana" size="1" <%=strColor%>><%=rsService("CompanyName")%></font></TD>
							<%if rsService("Status")= "I" then %>
							<TD align="center"><font face="Verdana" size="1" <%=strColor%>><a class='tooltip' href='newCall.aspx?system=365&ServiceCode=<%=rsService("ServiceCode")%>&Status=<%=rsService("Status")%>' title='<%=rsService("Description")%>'><%=rsService("ServiceCode")%></a></font></TD>
							<%else %>
							<TD align="center"><font face="Verdana" size="1" <%=strColor%>><a class='tooltip' href='CallDetails.aspx?ServiceCode=<%=rsService("ServiceCode")%>&Read=1&Status=O' title='<%=rsService("Description")%>'><%=rsService("ServiceCode")%></a></font></TD>
							<%end if 
							
							if  (Session("MJSystem") <> "O2ESS") then %>
							<TD align="center"><font face="Verdana" size="1" <%=strColor%>><%=rsService("LoggedBy")%></font></TD>
							<%end if %>
							
							<TD><font face="Verdana" size="1" <%=strColor%>><%=rsService("CContactName")%></font></TD>
							<TD><font face="Verdana" size="1" <%=strColor%>><%=Left(rsService("DateModified"),Len(rsService("DateModified"))-3)%></font></TD>
							<TD width="260px"><font face="Verdana" size="1" <%=strColor%>><%=rsService("LastDescription")%></font></TD>
							<TD><font face="Verdana" size="1" <%=strColor%>>
							    <%
							        Select Case rsService("Status")
						                Case "X"
							                Response.Write("All")
						                Case "O"
							                Response.Write("Open")
							            Case "I"
							                Response.Write("Assigned from Tier 1")
						                Case "A"
							                Response.Write("Assigned")
						                Case "R"
							                Response.Write("Closed by Technician")
						                Case "C"
							                Response.Write("Closed by Dispatcher")
						                Case "F"
							                Response.Write("Closed by Customer")
						                Case "H"
							                Response.Write("Cancelled")
					                End Select
							%>
							
							</font></TD>
							<TD>
						
						<% 
						
						Dim rsTechnicians, o2essfilter
        
        if (Session("MJSystem") = "O2ESS") then
            o2essfilter = " and not (t.ESSQUEUE is null) "
            'o2essfilter = " and ((t.ESSQUEUE = (Select TOP 1 CallCategoryID from CallCategory where CallCategoryName = '- All -')) or (t.ESSQUEUE = " & cstr(rsService("CallCategoryID"))& ")) "
            
        end if
        
        if DbGroupId = ALPHA_GUESTS then     
            sql = "SELECT t.TechnicianCode, t.Username, t.Name, u.GroupID FROM Technician AS t JOIN [User] AS u ON t.Username = u.Login WHERE u.groupID = " & ALPHA_GUESTS & " and (t.IsDeleted = 0) ORDER BY t.Name"
        else
             sql = "SELECT t.TechnicianCode, t.Username, t.Name, u.GroupID FROM Technician AS t JOIN [User] AS u ON t.Username = u.Login WHERE u.groupID <> " & ALPHA_GUESTS & o2essfilter & " and (t.IsDeleted = 0) ORDER BY t.Name"
        end if


        'Dim rsConnTechnicians 
        'set rsConnTechnicians = objconn.Query(sql)
        'response.Write(sql)
        Set rsTechnicians = Server.CreateObject("ADODB.Recordset")
        
        rsTechnicians.CursorLocation = adUseClient
        rsTechnicians.LockType = adLockBatchOptimistic
        rsTechnicians.Open sql, objConn.objDbConnectionPublic
        
        Set rsTechnicians.ActiveConnection = Nothing 
						if (rsService("Status") <> "I" and not rsTechnicians.BOF  )then 
						rsTechnicians.MoveFirst %>
						<SELECT name="cboTechnician" class="cboAssignCls" serviceCode="<%=rsService("ServiceCode")%>" style="width: 175px">
                            <option value="-1">-- Assign to --</option>
                            <%While Not rsTechnicians.EOF%>
		                        <option value="<%=rsTechnicians("TechnicianCode")%>" 
		                        <%if Request("cboTechnician") = rsTechnicians("TechnicianCode") then 
		                            response.write("selected=selected")
		                            end if %>
		                        ><%=rsTechnicians("Name") %></option>
		                    <% rsTechnicians.MoveNext
		                    Wend %>
		                  
                            </SELECT>
                            <%
                            
                            else %>
                            <font face="Verdana" size="1">-No technicians available-</font>
                            <%
                            
                            end if%>
                            <br />
                            
                            
                            <%if DbGroupId <> ALPHA_GUESTS then
                            rsCallCategory.MoveFirst %>
                            <SELECT name="cboCallCategory" style="width: 175px" class="cboMoveToCls" serviceCode="<%=rsService("ServiceCode")%>">
		                      
		                        <% 
		                        if true then '(Session("MJSystem") <> "O2ESS") then  ** if this change is reverted O2ESS will not be available to select their callcategory
		                                While not rsCallCategory.EOF %>
                                            <option value='<%=rsCallCategory("CallCategoryID") %>' <%if cstr(rsCallCategory("CallCategoryID"))= cstr(rsService("CallCategoryID")) then response.write("selected=selected") end if  %>>
                                                <%= rsCallCategory("CallCategoryName")%></option>
                                            <% rsCallCategory.MoveNext
                                         Wend 
                                else
                                
                                        While not rsCallCategory.EOF 
                                                    if (cstr(rsCallCategory("CallCategoryID"))= cstr(rsService("CallCategoryID"))) then%>
                                                    <option value='<%=rsCallCategory("CallCategoryID") %>' selected = "selected" >
                                                        <%= rsCallCategory("CallCategoryName")%></option>
                                                    <%  
                                                        
                                                    end if
                                                    rsCallCategory.MoveNext
                                         Wend
                                end if%>
                            </SELECT>
                            <%end if %>
                            <%if DbGroupId = ALPHA_GUESTS then %>
                                 <input id="btntier" type="button"  serviceCode="<%=rsService("ServiceCode")%>" value="Assign Tier 2" class="btnAssignTier"   />
                            <%end if 
                                                        
                            if (DbGroupId <> ALPHA_GUESTS) and (Session("MJSystem") = "365") then %>
                            <br />
                             <input id="btntier1" type="button"  serviceCode="<%=rsService("ServiceCode")%>" value="Assign to Tier 1" class="btnAssignTier1"   />
                             <% if rsService("Status") <> "I" then %>
                             <input id="btnService" type="button"  serviceCode="<%=rsService("ServiceCode")%>" value="To ServiceDesk" class="btnService"   />
                            <%end if %>
                            
                            <%end if%>
                            
                            <%if  Session("MJSystem") = "ServiceDesk" then%>
                                <div>
                                
                                    <input type="text" name="scheduleTime" serviceCode="<%=rsService("ServiceCode")%>" class="datetimepicker scheduleTime" /><br />
                                    <input type="text" class="estDay" serviceCode="<%=rsService("ServiceCode")%>" style="width:30px;" value="0"/>d
                                    <input type="text" class="estHour" serviceCode="<%=rsService("ServiceCode")%>" style="width:30px;" value="1"/>h
                                    <input type="text" class="estMinute" serviceCode="<%=rsService("ServiceCode")%>" style="width:30px;" value="0"/>m
                                    <br />
                                    <input type="button"  serviceCode="<%=rsService("ServiceCode")%>" value="Assign" class="btnAssign" serviceCode="<%=rsService("ServiceCode")%>"   />
                                </div>
                            <%end if %>
                            </TD>
                            </form>
                </tr>
                <%
							i= i+1
							rsService.MoveNext
						wend
                %>
            </table>
            <br /><br />
            
            <!-----------------------------------------------------------------------------------------------
        
            Tier 1 list calls for tier 2 users in system 365 
     
            ----------------------------------------------------------------------------------------------->
          <%if  (Session("MJSystem") = "365") or (Session("MJSystem") = "ServiceDesk") then  
          			

          
                    Set rsService = Server.CreateObject("ADODB.Recordset")
        
                    rsService.CursorLocation = adUseClient
                    rsService.LockType = adLockBatchOptimistic
                    rsService.Open queryString2, objConn.objDbConnectionPublic
                    
                    Set rsService.ActiveConnection = Nothing 
						
						
						
				    	callCount = 0
						while not rsService.EOF 
						    callCount = callCount + 1
						    rsService.MoveNext
						Wend
						if  callCount > 0 then
						    rsService.MoveFirst
						end if
						
						    
            %>
            <%if  (Session("MJSystem") = "365") or (Session("MJSystem") = "ServiceDesk") then %>
            <div id="PageContentTitle" style="margin-bottom: 10px; padding: 5px; background-color: #EBE3CD;
                font-weight: bold;" class="ui-state-hover ui-corner-all">
              
               <% if (DbGroupId <> ALPHA_GUESTS)  then %>
                 Tier 1 Calls
               <%else %>
                Tier 2 Calls
               <%end if %>
            </div>
            <%end if %>
           
            <p>
                Call Count: <strong>
                    <%=callCount %></strong>
            </p>
           
            <table style="border: 1px solid #666666" width="100%" cellpadding="0" cellspacing="0">
                <tr>
                    <td>
                        <table width="100%">
                            <tr>
                                <td bgcolor="#D0D0D0" width="110px">
                                    <font face="Verdana" size="1">Order Time</font>
                                </td>
                                <td bgcolor="#D0D0D0">
                                    <font face="Verdana" size="1" width="100">Company</font>
                                </td>
                                <td bgcolor="#D0D0D0" align="center" width="50">
                                    <font face="Verdana" size="1">Code</font>
                                </td>
                                <td bgcolor="#D0D0D0" align="center">
                                    <font face="Verdana" size="1">Logged By</font>
                                </td>
                                <td bgcolor="#D0D0D0">
                                    <font face="Verdana" size="1">Contact</font>
                                </td>
                                <td bgcolor="#D0D0D0" width="110px">
                                    <font face="Verdana" size="1">Last Update</font>
                                </td>
                                <td bgcolor="#D0D0D0" width="260px">
                                    <font face="Verdana" size="1">Description</font>
                                </td>
                                <%If intCategory = 1 Then%>
                                <td bgcolor="#D0D0D0">
                                    <font face="Verdana" size="1">SLA</font>
                                </td>
                                <%End if%>
                                <td bgcolor="#D0D0D0">
                                    <font face="Verdana" size="1">Status</font>
                                </td>
                                <td bgcolor="#D0D0D0">
                                    <font face="Verdana" size="1">Action</font>
                                </td>
                            </tr>
                            <%
						i = 0
						if rsService.EOF then
                            %>
                            <tr>
                                <td colspan="9">
                                    <font face="Verdana" size="1">No outstanding calls.</font>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="9">
                                    <table width="100%" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td bgcolor="#D0D0D0">
                                                <img src="/images/trans.gif" width="20" height="1" border="0">
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <%
						End If%>
						
                            <%While not rsService.EOF %>
                            <form name="frmAssign" id="Form1" action="scOutstanding.asp" method="GET">
                            <input type="hidden" name="hidService" id="Hidden1" value='<%=rsService("ServiceCode")%>' />
                            <input type="hidden" name="hidTech" id="Hidden2" value="-1" />
                            <input type="hidden" name="hidReturnUrl" id="Hidden3" value="-1" />
                            <%
							strResponseAbsoluteTime=""
							strColor =""
							strBgColor=""
							
								
									If DateDiff("n", CDate(rsService("OrderTime")),Now())> (60 * 23) Then
										strColor = " color=""Red"" " 'Red
									ElseIf DateDiff("n", rsService("OrderTime"),Now())> (60*20) Then
										strColor = " color=""Orange"" "  'Orange
									Else
										strColor = " color=""Green"" "  'GreenYellow
									End If
												if rsService("Priority") = "H" or rsService("Priority") = "1" or rsService("Priority") = "A" or rsService("Priority") = "B"  then
								strColor= strColor & " ><B"
							else
								strColor = strColor & ""
							end if
                            %>
                            <tr>
                                <td colspan="9" style="border-top: 1px solid #D0D0D0">
                                    <img src="/images/trans.gif" width="1" height="2" border="0">
                                </td>
                            </tr>
                            <TR<%=strBgColor%>>
						    <TD><font face="Verdana" size="1" <%=strColor%>><%=Left(rsService("COrderTime"),Len(rsService("COrderTime"))-3)%></font></TD>
							<TD><font face="Verdana" size="1" <%=strColor%>><%=rsService("CompanyName")%></font></TD>
							 <%if  (DbGroupId <> ALPHA_GUESTS) then  
	        				        if rsService("Status")= "I" then %>
							        <TD align="center"><font face="Verdana" size="1" <%=strColor%>><a class='tooltip' href='newCall.aspx?system=365&ServiceCode=<%=rsService("ServiceCode")%>&Status=<%=rsService("Status")%>' title='<%=rsService("Description")%>'><%=rsService("ServiceCode")%></a></font></TD>
							        <%else %>
							        <TD align="center"><font face="Verdana" size="1" <%=strColor%>><a class='tooltip' href='CallDetails.aspx?ServiceCode=<%=rsService("ServiceCode")%>&Read=1&Status=O' title='<%=rsService("Description")%>'><%=rsService("ServiceCode")%></a></font></TD>
							        <%end if 
							  else%>
							  <!--<TD align="center"><font face="Verdana" size="1" <%=strColor%>><%=rsService("ServiceCode")%></font></TD>-->
							      <%  if rsService("Status")= "I" then %>
							        <TD align="center"><font face="Verdana" size="1" <%=strColor%>><%=rsService("ServiceCode")%></font></TD>
							        <%else %>
							        <TD align="center"><font face="Verdana" size="1" <%=strColor%>><a class='tooltip' href='CallDetails.aspx?ServiceCode=<%=rsService("ServiceCode")%>&Read=1&Status=O&Source=T2' title='<%=rsService("Description")%>'><%=rsService("ServiceCode")%></a></font></TD>
							        <%end if 
							  end if %>
							<TD align="center"><font face="Verdana" size="1" <%=strColor%>><%=rsService("LoggedBy")%></font></TD>
							<TD><font face="Verdana" size="1" <%=strColor%>><%=rsService("CContactName")%></font></TD>
							<TD><font face="Verdana" size="1" <%=strColor%>><%=Left(rsService("DateModified"),Len(rsService("DateModified"))-3)%></font></TD>
							<TD><font face="Verdana" size="1" <%=strColor%>><%=rsService("LastDescription")%></font></TD>
							<TD><font face="Verdana" size="1" <%=strColor%>>
							    <%
							        Select Case rsService("Status")
						                Case "X"
							                Response.Write("All")
						                Case "O"
							                Response.Write("Open")
							            Case "I"
							                Response.Write("Incomplete")
						                Case "A"
							                Response.Write("Assigned")
						                Case "R"
							                Response.Write("Closed by Technician")
						                Case "C"
							                Response.Write("Closed by Dispatcher")
						                Case "F"
							                Response.Write("Closed by Customer")
						                Case "H"
							                Response.Write("Cancelled")
					                End Select
							%>
							
							</font></TD>
							<%if (DbGroupId <> ALPHA_GUESTS) and (Session("MJSystem") = "365") then %>
							<TD>
						
						<% if (rsService("Status") <> "I" )then 
						
				
        
        if (Session("MJSystem") = "O2ESS") then
            o2essfilter = " and not (t.ESSQUEUE is null) "
            'o2essfilter = " and ((t.ESSQUEUE = (Select TOP 1 CallCategoryID from CallCategory where CallCategoryName = '- All -')) or (t.ESSQUEUE = " & cstr(rsService("CallCategoryID"))& ")) "
            
        end if
        
        if DbGroupId = ALPHA_GUESTS then     
            sql = "SELECT t.TechnicianCode, t.Username, t.Name, u.GroupID FROM Technician AS t JOIN [User] AS u ON t.Username = u.Login WHERE u.groupID = " & ALPHA_GUESTS & " and (t.IsDeleted = 0) ORDER BY t.Name"
        else
             sql = "SELECT t.TechnicianCode, t.Username, t.Name, u.GroupID FROM Technician AS t JOIN [User] AS u ON t.Username = u.Login WHERE u.groupID <> " & ALPHA_GUESTS & o2essfilter & " and (t.IsDeleted = 0) ORDER BY t.Name"
        end if


        'Dim rsConnTechnicians 
        'set rsConnTechnicians = objconn.Query(sql)
        'response.Write(sql)
        Set rsTechnicians = Server.CreateObject("ADODB.Recordset")
        
        rsTechnicians.CursorLocation = adUseClient
        rsTechnicians.LockType = adLockBatchOptimistic
        rsTechnicians.Open sql, objConn.objDbConnectionPublic
						rsTechnicians.MoveFirst %>
						<SELECT name="cboTechnician" class="cboAssignCls" serviceCode="<%=rsService("ServiceCode")%>">
                            <option value="-1">-- Assign to --</option>
                            <%While Not rsTechnicians.EOF%>
		                        <option value="<%=rsTechnicians("TechnicianCode")%>" 
		                        <%if Request("cboTechnician") = rsTechnicians("TechnicianCode") then 
		                            response.write("selected=selected")
		                            end if %>
		                        ><%=rsTechnicians("Name") %></option>
		                    <% rsTechnicians.MoveNext
		                    Wend %>
		                  
                            </SELECT>
                            <%end if%>
                            <br />
                            
                            
                            <%if DbGroupId <> ALPHA_GUESTS then
                            rsCallCategory.MoveFirst %>
                            <SELECT name="cboCallCategory" class="cboMoveToCls" serviceCode="<%=rsService("ServiceCode")%>">
		                      
		                        <% 
		                        'if (Session("MJSystem") <> "O2ESS") then
		                        if true then
		                                While not rsCallCategory.EOF %>
                                            <option value='<%=rsCallCategory("CallCategoryID") %>' <%if cstr(rsCallCategory("CallCategoryID"))= cstr(rsService("CallCategoryID")) then response.write("selected=selected") end if  %>>
                                                <%= rsCallCategory("CallCategoryName")%></option>
                                            <% rsCallCategory.MoveNext
                                         Wend 
                                else
                                
                                        While not rsCallCategory.EOF 
                                                    if (cstr(rsCallCategory("CallCategoryID"))= cstr(rsService("CallCategoryID"))) then%>
                                                    <option value='<%=rsCallCategory("CallCategoryID") %>' selected = "selected" >
                                                        <%= rsCallCategory("CallCategoryName")%></option>
                                                    <%  
                                                        
                                                    end if
                                                    rsCallCategory.MoveNext
                                         Wend
                                end if%>
                            </SELECT>
                            <%end if %>
                           
                            
                            <%if  Session("MJSystem") = "ServiceDesk" then%>
                                <div>
                                
                                    <input type="text" name="scheduleTime" serviceCode="<%=rsService("ServiceCode")%>" class="datetimepicker scheduleTime" /><br />
                                    <input type="text" class="estDay" serviceCode="<%=rsService("ServiceCode")%>" style="width:30px;" value="0"/>d
                                    <input type="text" class="estHour" serviceCode="<%=rsService("ServiceCode")%>" style="width:30px;" value="1"/>h
                                    <input type="text" class="estMinute" serviceCode="<%=rsService("ServiceCode")%>" style="width:30px;" value="0"/>m
                                    <br />
                                    <input type="button"  serviceCode="<%=rsService("ServiceCode")%>" value="Assign" class="btnAssign" serviceCode="<%=rsService("ServiceCode")%>"   />
                                </div>
                            <%end if %>
                            </TD>
						<%end if %>
                           
                            </form>
                </tr>
                <%
							i= i+1
							rsService.MoveNext
						wend
                %>
            </table>
       <%end if %>      
            <!-- ----------------------------------------------------------------------------------------------
            END Tier 1 list calls for tier 2 users in system 365 -->
            <hr>
           
        </td>
    </tr>
    <%
		Dim strCreationTime, rsMessage

		Set rsMessage = objConn.Query("select MessageID, Description, convert(varchar(20),CreationTime,113) as CCreationTime, CreationTime, TechnicianCode from Message where Status = 1 order by CreationTime")
		If not rsMessage.EOF Then

    %>
    <tr>
        <td>
           
        </td>
    </tr>
    <%
					End If
    %>
    </TD> </TR>
</table>
</table>


<!--  End Main  -->
<%
end if '  f  (Session("MJSystem") <> "O2ESS") or  (DbGroupId >= ALPHA_DISPATCHERS) then

Set objConn = Nothing
EndPage
%>
</html>
<%
 End Sub



 '********************************************************************
 ' Server-Side Functions
 '********************************************************************


%>