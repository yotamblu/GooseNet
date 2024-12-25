<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="ConfirmConnection.aspx.cs" Inherits="GooseNet.ConfirmConnection" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

<style>    
    
    h3 {

        font-size:4vw;
    }
    check{

    }
</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <center><h3>Do you wish to connect with Coach <%=GetCoachName()%>?</h3></center>

    <button><a href="HandleConnection.aspx?CoachName=<%=GetCoachName() %>">Connect!</a></button>
</asp:Content>
