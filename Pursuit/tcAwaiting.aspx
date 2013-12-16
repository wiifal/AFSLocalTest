<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true"
    CodeFile="tcAwaiting.aspx.cs" Inherits="tcAwaiting" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    Assigned Calls
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="scripts" runat="Server">
    <%--<script src="js/jquery-1.4.2.min.js" type="text/javascript"></script>--%>

    <script src="js/jquery.tooltip.js" type="text/javascript"></script>

    <link href="stylesheets/jquery.tooltip.css" rel="stylesheet" type="text/css" />

    <script src="js/jquery.simpleAutocomplete.js" type="text/javascript"></script>

    <link href="stylesheets/ui.selectmenu.css" rel="stylesheet" type="text/css" />

    <script src="js/ui.selectmenu.js" type="text/javascript"></script>

    <script type="text/javascript">
        $(document).ready(function() {
            $(".jtable th").each(function() {
                $(this).addClass("ui-state-default");
            });

            $(".jtable td").each(function() { $(this).addClass("ui-widget-content"); });

            //            $(".jtable tr").hover(function() { $(this).children("td").addClass("ui-state-hover"); }
            //            , function() { $(this).children("td").removeClass("ui-state-hover"); });

            $(".TechTitle").click(function() {
                $(this).nextAll().find(".jtable").first().slideToggle();
            });

            $(".travel").each(function() {
                if ($(this).val() == "True") {
                    $(this).parent().parent().addClass("blueBackground");
                    $(this).parent().parent().find("td").removeClass("ui-widget-content");
                } else {
                    $(this).parent().parent().removeClass("blueBackground");
                }
            });
            $(".onsite").each(function() {
                if ($(this).val() == "True") {
                    $(this).parent().parent().addClass("greenBackground");
                    $(this).parent().parent().find("td").removeClass("ui-widget-content");
                } else {
                    $(this).parent().parent().removeClass("greenBackground");
                }
            });

            $(".SLAExpired").each(function() {
                     $(this).find("td").removeClass("ui-widget-content");
                
            });

            $("#travelcount").text(($(".blueBackground").length -1 ));
            $("#onsitecount").text(($(".greenBackground").length - 1));
            $("#newcallcount").text(($(".newCallRow").length));
            $("#slaexiprycount").text(($(".SLAExpired").length));
            
            //$(".tooltip").tooltip({ extraClass: "tooltipClass" });

            // $('[ID$=ddlCallType]').selectmenu({ style: 'dropdown' });
            $('[ID$=FilterButton]').button();
            //            $('[ID$=txtClient]').button().css({
            //                'font': 'inherit',
            //                'color': 'inherit',
            //                'text-align': 'left',
            //                'outline': 'none',
            //                'cursor': 'text'
            //            });

        });

        
    </script>

    <style type="text/css">
        .blueBackground
        {
            background-color:lightblue;
        }
        .greenBackground
        {
            background-color:lightgreen;
        }
        .redBackground
        {
            background-color:red;
        }
        .TechTitle
        {
            cursor: pointer;
        }
        .jtable td, .jtable th
        {
            padding: 3px;
            font-weight: normal !important;
        }
        .tooltipClass
        {
            font-size: 9px;
            font-weight: normal;
            font-family: Verdana, Arial, Helvetica, sans-serif;
        }
        #tblFilters td
        {
            padding: 3px;
        }
        #tblCount td
        {
            padding: 3px;
        }
        .SLAExpired td
        {
            background-color:  Red !important;
        }
        .newCallRow td
        {
            font-weight: bold !important;
           
        }
        
    </style>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="contentTitle" runat="Server">
    <asp:Literal ID="txtTitle" runat="server" Text="Assigned Calls" />
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="content" runat="Server">
    <div id="filters" class="ui-corner-all ui-widget-content" style="padding: 5px; margin-bottom: 10px;
        float: left; width: 45%;">
        <table id="tblFilters">
            <tr>
                <td>

                    <!-- That's a sample comment for change management system-->
                    <asp:Label runat="server" ID="lblIssueType" Text="Case Type:" Visible = "true" ></asp:Label>
                </td>
                <td>
                    <asp:DropDownList ID="ddlCallType" runat="server" DataTextField="CallCategoryName"
                        DataValueField="CallCategoryID" AppendDataBoundItems="true">
                        <asp:ListItem Text="-- All --" Value="-1" />
                    </asp:DropDownList>
                </td>
            </tr>
            <tr id="txtcust" runat = "server">
                <td>
                    <asp:Label runat="server" ID="lblcustomer" Text="Customer:" Visible = "true" ></asp:Label>
                </td>
                <td>
                    <asp:TextBox ID="txtClient" runat="server" CssClass="txtAutocomplete" ajaxurl="ws/CoreService.asmx/GetClientsByCompanyName"
                        getalldataatonce="false" mincharsnumber="2" autocompletedestinationid='txtClientCodeHid'
                        allownewentry="false" Style="width: 250px;"></asp:TextBox>
                    <input type="hidden" name="txtClientCodeHid" id="txtClientCodeHid" value='<%=Request.Form["txtClientCodeHid"] %>' />
                </td>
            </tr>
            
            <tr id="txtcust2" runat = "server" visible="false">
                <td>
                    <asp:Label runat="server" ID="Label1" Text="Customer:" Visible = "true" ></asp:Label>
                </td>
                <td>
                    <asp:TextBox ID="txtClient2" runat="server"  CssClass="txtAutocomplete" ajaxurl="ws/CoreService.asmx/GetClientsByCompanyNameTier"
                        getalldataatonce="false" mincharsnumber="2" autocompletedestinationid="txtClient2CodeHid"
                        allownewentry="false" Style="width: 250px;font-weight: normal !important;"></asp:TextBox>
                       <input type="hidden" name="txtClient2CodeHid" id="txtClient2CodeHid" runat="server" />
                
                </td>
            </tr>
            <tr>
                <td style="width: 150px;">
                    <asp:Label runat="server" ID="lblSLA" Text="SLA Expired:" visible = "false" ></asp:Label>
                </td>
                <td>
               
                   
                <asp:DropDownList ID="DDLSLA" runat="server" AppendDataBoundItems="true" visible = "false">
                        <asp:ListItem Text="-- All --" Value="-1" />
                        <asp:ListItem Text="Expired" Value="1" />
                        <asp:ListItem Text="Not Expired" Value="0" />
                    </asp:DropDownList>
               
                   
                </td>
            </tr>
            <tr>
                <td style="width: 150px;">
                    <asp:Label runat="server" ID="lblVEC" Text="ESS:" Visible = "false" ></asp:Label>
                </td>
                <td>
               
                    <asp:DropDownList ID="DDLVEC" runat="server" DataTextField="CompanyName"
                        DataValueField="ClientCode" AppendDataBoundItems="true" Visible = "false">
                        <asp:ListItem Text="-- All --" Value="-1" />
                    </asp:DropDownList>
                </td>
            </tr>
            <tr>
                <td style="width: 150px;">
                    <asp:Label runat="server" ID="lblSchool" Text="School:" Visible = "false" ></asp:Label>
                </td>
                <td>
               
                    <asp:DropDownList ID="DDLSchool" style="width: 250px;" runat="server" DataTextField="CompanyName"
                        DataValueField="ClientCode" AppendDataBoundItems="true" Visible = "false" 
                        >
                        <asp:ListItem Text="-- All --" Value="-1" />
                    </asp:DropDownList>
                </td>
            </tr
            
            <tr>
                <td style="width: 150px;">
                    <asp:Label runat="server" ID="lbltier" Text="Tier:" Visible = "false" ></asp:Label>
                </td>
                <td>
               
                    <asp:DropDownList ID="DDLTier" style="width: 250px;" runat="server" DataTextField="CompanyName"
                        DataValueField="ClientCode" AppendDataBoundItems="true" Visible = "false" 
                     >
                        <asp:ListItem Text="-- All --" Value="0" />
                        <asp:ListItem Text="1" Value="1" />
                        <asp:ListItem Text="2" Value="2" />
                    </asp:DropDownList>
                </td>
            </tr>
            
           
            <tr>
                <td>
                </td>
                <td style="text-align: right;">
                    <asp:Button ID="FilterButton" runat="server" Text="Filter" OnClick="FilterButton_Click" />
                </td>
            </tr>
            
            
            <tr>
            <td>&nbsp;</td>
            </tr>
        </table>
        <br />
    </div>
    <div class="ui-corner-all ui-widget-content" style="padding: 5px; margin-bottom: 10px;
        float: right; width: 45%;">
        <table id="tblCount">
            <tr>
                <td>
                    Total Open Calls:
                
                </td>
                <td>
                    <asp:Literal ID="lTotalOpenCalls" runat="server" />
                </td>
            </tr>
            <tr>
                <td>
                    Total Assigned Calls:
                </td>
                <td>
                    <asp:Literal ID="lTotalAssignedCalls" runat="server" />
                </td>
            </tr>
        </table>
    </div>
    <div class="ui-corner-all ui-widget-content" style="padding: 5px; margin-bottom: 10px;
        float: right; width: 45%;">
        <table id="Table1">
            <tr>
                <td style="width:10.7em;">
                    Traveling:
                </td>
                <td  class="blueBackground" style="width:3em;">
                    <div  style="left: 0.5em;position: relative;"  id="travelcount"></div>
                </td>
            </tr>
            <tr>
                <td style="width:10.7em;" >
                    Onsite:
                </td>
                <td class="greenBackground">
                    <div  style="left: 0.5em;position: relative;"   id="onsitecount"></div>
                </td>
            </tr>
            <tr>
                <td style="width:10.7em;" >
                    New Calls:
                </td>
                <td >
                    <div  style="font-weight:bold;left: 0.5em;position: relative;"   id="newcallcount"></div>
                </td>
            </tr>
            <tr>
                <td style="width:10.7em;" >
                    SLA Expired:
                </td>
                <td class="redBackground" >
                    <div  style="left: 0.5em;position: relative;"   id="slaexiprycount"></div>
                </td>
            </tr>
        </table>
        </div>
        <asp:ListView ID="lvCalls" runat="server" 
      style="text-align: left">
        <LayoutTemplate>
            <table id="itemPlaceholder" runat="server" />
        </LayoutTemplate>
        <ItemTemplate>
            <table style="width: 100%;" class="ui-state-active ui-corner-all TechTitle ui-widget">
                <tr>
                    <td style="width: 33%">
                        <%# Eval("TechnicianName")%>
                    </td>
                    <td style="width: 33%">
                        Calls:
                        <%# Eval("Count")%>
                        of
                        <%# Eval("TotalCount")%>
                    </td>
                    <td style="width: 33%; text-align: right;">
                        Last Login:
                        <%# Eval("LastLoginDate")%>
                    </td>
                </tr>
            </table>
            <div>
                <asp:GridView Style="width:100%; margin-bottom: 20px; font-size: 11px;" CssClass="jtable ui-widget-content ui-corner-all"
                    ID="gvTechCalls" runat="server" AutoGenerateColumns="False" DataSource='<%# Eval("Calls") %>'
                    OnRowDataBound="gvTechCalls_RowDataBound" OnPreRender="gvTechCalls_Prerender">
                    <Columns>
                    <asp:TemplateField HeaderText="Tier" ItemStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                               <asp:Label runat="server" ID="lblRowTier" Text='<%# Eval("Tier") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Stage" ItemStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <asp:Label runat="server" ID="lblStage" Text='<%# Eval("StageName") %>' />
                                <input type="hidden"  class="travel" Value='<%# Eval("Traveling") %>' />
                                <input type="hidden" class="onsite" Value='<%# Eval("OnSite") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Case Type" ItemStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <asp:Label runat="server" ID="lblCategoryName" Text='<%# Eval("CallCategoryName") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Customer">
                            <ItemTemplate>
                                <asp:Label runat="server" ID="lblOwnerC" Text='<%# Eval("OwnerCName") %>' />
                                <asp:Label runat="server" ID="lblCompanyName" Text='<%# Eval("CompanyName") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Reference No." ItemStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <asp:Label runat="server" ID="lblServiceCode" Text='<%# Eval("ServiceCode") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Contact Name">
                            <ItemTemplate>
                                <asp:Label runat="server" ID="lblContactName" Text='<%# Eval("ContactName") %>'  />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Schedule Time" ItemStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <asp:Label runat="server" ID="lblscheduleTime" Text='<%# Eval("ScheduleTime","{0:g}") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Description">
                            <ItemTemplate>
                                <asp:Label runat="server" CssClass="tooltip" ID="lblDescription" Text='<%# Eval("LastDescription") %>'
                                    ToolTip='<%# Eval("LastPostText") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Last Update" ItemStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <asp:Label runat="server" ID="lblDateModified" Text='<%# Eval("DateModified","{0:g}") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        
                        <asp:TemplateField HeaderText="Action" ItemStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                            
     
                                    <asp:HyperLink  ID="HyperLink1" runat="server" NavigateUrl='<%# String.Format("CallDetails.aspx?Tech={0}&ServiceCode={1}&red=1",Eval("TechnicianCode"),Eval("ServiceCode")) %>'>Edit</asp:HyperLink>
                                    <br />
                                    <br />
                                <div runat="server" id="divRelease" visible='<%# Eval("CanRelease") ?? false %>'>
                                    <asp:LinkButton CommandArgument='<%# Eval("SessionID").ToString() + ","+Eval("ServiceCode").ToString() %>' ID="lRelease" runat="server"
                                        Visible='<%# Eval("CanRelease") ?? false %>' OnClick="lRelease_Click" OnClientClick="return confirm('Are you sure?');">Release</asp:LinkButton>
                                <br />
                                <br />
                                </div>
                                <div>
                                    <a href="javascript:void(0);" id="LinkButton1" runat="server" onclick='<%#String.Format("javascript:window.open(\"tcAddTechnician.asp?Tech={0}&ServiceCode={1}&SessionID={2}\",\"AddTechnicianToCall\",\"width=600,height=450,scrollbars=yes\");", Eval("TechnicianCode"), Eval("ServiceCode"), Eval("SessionID"))%> '>
                                        Add Technician</a>
                                </div>
                          
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </ItemTemplate>
    </asp:ListView>
    </asp:Content>
