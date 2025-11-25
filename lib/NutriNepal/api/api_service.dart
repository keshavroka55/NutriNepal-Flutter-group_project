// API base urls
// lib/utils/constants.dart

// Base URL of your Node backend API
// the mongodb cluster is created on learnpoadcast gmail id ok..
// const String apiBaseUrl = "https://nutrinepal-node-api.onrender.com";
const String apiBaseUrl = "http://10.0.2.2:5000";
// API Endpoints
const String registerEndpoint = "$apiBaseUrl/api/auth/v1/register";
const String loginEndpoint = "$apiBaseUrl/api/auth/v1/login";
const String foodEndpoint = "$apiBaseUrl/api/foods";
const String logsEndpoint = "$apiBaseUrl/api/logs";
