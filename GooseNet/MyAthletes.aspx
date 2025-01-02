<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="MyAthletes.aspx.cs" Inherits="GooseNet.MyAthletes" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Athletes - GooseNet</title>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

   <%ShowConnectedAthletes(GetConnectedAthletes()); %>

</asp:Content>
