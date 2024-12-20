<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="HandleConnection.aspx.cs" Inherits="GooseNet.HandleConnection" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <h3>Successfully Connected With Coach <%= Request.QueryString["CoachName"] %></h3>
</asp:Content>
