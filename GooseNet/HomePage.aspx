<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="HomePage.aspx.cs" Inherits="GooseNet.HomePage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <title>GooseNet</title>
    <style>
             .hero {
            text-align: center;
            padding: 50px;
            background: linear-gradient(to right, #1e1e24, #252530);
            border-radius: 10px;
            margin: 20px;
        }
        .hero h2 {
            font-size: 2.5em;
            margin-bottom: 10px;
        }
        .hero p {
            font-size: 1.2em;
            color: #d1d1d1;
        }
        .cta-button {
            display: inline-block;
            padding: 10px 20px;
            background: #ff6b6b;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            transition: background 0.3s;
        }
        .cta-button:hover {
            background: #ff5252;
        }
        .features {
            display: flex;
            justify-content: space-around;
            flex-wrap: wrap;
            padding: 40px;
        }
        .feature {
            background: #252530;
            padding: 20px;
            border-radius: 10px;
            width: 30%;
            text-align: center;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        .feature h3 {
            color: #ff6b6b;
            font-size: 1.5em;
        }
        .feature p {
            color: #d1d1d1;
        }
        footer {
            text-align: center;
            padding: 20px;
            background: #18181b;
            margin-top: 20px;
        }
    
        <!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>GooseNet - Home</title>
    <link rel="stylesheet" href="styles.css">
    <style>
        .hero {
            text-align: center;
            padding: 50px;
            background: linear-gradient(to right, #1e1e24, #252530);
            border-radius: 10px;
            margin: 20px;
        }
        .hero h2 {
            font-size: 2.5em;
            margin-bottom: 10px;
        }
        .hero p {
            font-size: 1.2em;
            color: #d1d1d1;
        }
        .cta-button {
            display: inline-block;
            padding: 10px 20px;
            background: #ff6b6b;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            transition: background 0.3s;
        }
        .cta-button:hover {
            background: #ff5252;
        }
        .features {
            display: flex;
            justify-content: space-around;
            flex-wrap: wrap;
            padding: 40px;
            gap: 20px;
        }
        .feature {
            background: #252530;
            padding: 20px;
            border-radius: 10px;
            width: 30%;
            text-align: center;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        .feature h3 {
            color: #ff6b6b;
            font-size: 1.5em;
        }
        .feature p {
            color: #d1d1d1;
        }
        footer {
            text-align: center;
            padding: 20px;
            background: #18181b;
            margin-top: 20px;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .hero {
                padding: 30px;
                margin: 10px;
            }
            .hero h2 {
                font-size: 2em;
            }
            .hero p {
                font-size: 1em;
            }
            .features {
                flex-direction: column;
                align-items: center;
            }
            .feature {
                width: 90%;
            }
            .cta-button {
                padding: 8px 16px;
                font-size: 1em;
            }
          


        }

    </style>
</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
      <section class="hero">
            <h2>Connecting Runners with Coaches & other Athletes</h2>
            <p>Track, share, and improve your running performance with GooseNet.</p>
            <a href="login.aspx" class="cta-button">Get Started</a>
        </section>
        
        <section id="features" class="features">
            <div class="feature">
                <h3>Seamless Garmin Integration</h3>
                <p>Sync your workouts directly from your Garmin device.</p>
            </div>
            <div class="feature">
                <h3>Share your Runs</h3>
                <p>Let others see your runs directly from your Garmin Devise</p>
            </div>
            <div class="feature">
                <h3>Connect with Coaches</h3>
                <p>Let your Coach gain insights into your performance.</p>
            </div>
        </section>
</asp:Content>
