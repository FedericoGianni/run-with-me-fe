class Config {
  static const String baseUrl = 'https://runwithme.msuki.tk';
  int apiTimeout = 20;
 
 String getBaseUrl(){
   return baseUrl;
 }

 int getApiTimeout(){
   return apiTimeout;
 }
}
