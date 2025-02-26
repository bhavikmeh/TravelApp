sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'trv/prcs/travelappprcs/test/integration/FirstJourney',
		'trv/prcs/travelappprcs/test/integration/pages/TravelList',
		'trv/prcs/travelappprcs/test/integration/pages/TravelObjectPage',
		'trv/prcs/travelappprcs/test/integration/pages/BookingObjectPage'
    ],
    function(JourneyRunner, opaJourney, TravelList, TravelObjectPage, BookingObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('trv/prcs/travelappprcs') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onTheTravelList: TravelList,
					onTheTravelObjectPage: TravelObjectPage,
					onTheBookingObjectPage: BookingObjectPage
                }
            },
            opaJourney.run
        );
    }
);