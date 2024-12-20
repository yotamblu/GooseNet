<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="ConnectAthlete.aspx.cs" Inherits="GooseNet.ConnectAthlete" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">


    Share This Coach Id with Athletes To connect to them:
    <br /><%=GetCoachId() %>


</asp:Content>
