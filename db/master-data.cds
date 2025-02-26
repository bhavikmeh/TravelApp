namespace sap.fe.cap.travel;

using {Country,Currency} from '@sap/cds/common';



entity TravelAgency {
  key AgencyID     : String(6);
      Name         : String(80);
      Street       : String(60);
      PostalCode   : String(10);
      City         : String(40);
      CountryCode  : Country;
      PhoneNumber  : String(30);
      EMailAddress : String(256);
      WebAddress   : String(256);
};

entity Passenger {
  key CustomerID   : String(6);
      FirstName    : String(40);
      LastName     : String(40);
      Title        : String(10);
      Street       : String(60);
      PostalCode   : String(10);
      City         : String(40);
      CountryCode  : Country;
      PhoneNumber  : String(30);
      EMailAddress : String(256);
      CustomerName : String = FirstName || ' ' || LastName;
};

entity Airline  {
  key AirlineID : String(3);
  Name          : String(40);
  CurrencyCode  : Currency; 

};

entity Flight {  
  key AirlineID    : String(3);
  key FlightDate   : Date;
  key ConnectionID : String(4);

  Price            : Decimal(16, 3);
  CurrencyCode     : Currency;
  PlaneType        : String(10);
  MaximumSeats     : Integer;
  OccupiedSeats    : Integer;

  to_Airline       : Association to Airline on to_Airline.AirlineID = AirlineID;
  to_Connection    : Association to FlightConnection on to_Connection.AirlineID = AirlineID
                       and to_Connection.ConnectionID = ConnectionID;
};

entity FlightConnection {  
  key ConnectionID   : String(4);
  key AirlineID      : String(3);
  DepartureAirport   : Association to Airport;
  DestinationAirport : Association to Airport;
  DepartureTime      : Time;
  ArrivalTime        : Time;
  Distance           : Integer;
  DistanceUnit       : String(3);

  to_Airline         : Association to Airline
                         on to_Airline.AirlineID = AirlineID;
};

entity Airport {
  key AirportID : String(3);
  Name          : String(40);
  City          : String(40);
  CountryCode   : Country;
};
