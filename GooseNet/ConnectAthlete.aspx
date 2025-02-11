<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="ConnectAthlete.aspx.cs" Inherits="GooseNet.ConnectAthlete" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
   <title>Connect Athlete</title>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <br />
    <br />
    <center>
    <span style="font-size:4vw;"> This Coach Id with Athletes To connect to them:</span><br />
    <input style="max-width:60vw;font-size:9vw;height:30vh;border:none" value="<%=GetCoachId() %>" readonly /><button  style="margin-left:1vw;" id="copyButton"><img width="150" src="Images/copyIcon.png"/></button>
        </center>
       
        <script>document.getElementById("copyButton").addEventListener("click", () => {

                navigator.clipboard.writeText('<%=GetCoachId()%>').then(() => {
        alert("Coach ID copied to clipboard. You can paste it anywhere.");
    }).catch(err => {
        console.error("Failed to copy text: ", err);
    });


});</script>
</asp:Content>
