const got = require('got');

const ZOOM_BASE_URL = 'https://api.zoom.us/v2/';

const ZOOM_USER_ID = 'D3HzE_hfR5yJ6Kyv5QqaDA';


function sendZoomRequest() {
    const requestMeetingBody = {
        "topic": "test-meeting-10",
        "type": "2",
        "start_time": "2020-04-15T18:10:00",
        "duration": "30",
        "timezone": "America/Los_Angeles",
        "agenda": "test agenda",
        "settings": {
            "host_video": "false",
            "participant_video": "true",
            "join_before_host": "true",
            "watermark": "false",
            "use_pmi": "false",
            "approval_type": "2",
            "audio": "both",
            "auto_recording": "none",
            "enforce_login": "false",
            "enforce_login_domains": "false",
            "registrants_confirmation_email:": "false",
            "registrants_email_notification": "true",
            "waiting_room": "false",
            "meeting_authentication": "false",
        }
    };

    (async () => {
        try {
            const response = await got.post(ZOOM_BASE_URL + `users/${ZOOM_USER_ID}/meetings`,
                {
                    headers: {
                        'Authorization': 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOm51bGwsImlzcyI6IklIWEs4RHh6UWxLQWttajc3NThaRmciLCJleHAiOjE1ODcwNjQwMTQsImlhdCI6MTU4Njk3NzYxNH0.4D1th1HdLrp4T-oZ8VjuvYk0o7jScPcleCw-Amt6VQA',
                    },
                    json: requestMeetingBody,
                    responseType: 'json',
                });

            console.log(response.body);

            const joinUrl = response.body['join_url'];
            const startUrl = response.body['start_url'];
            console.log(joinUrl);
            console.log(startUrl);

        } catch (error) {
            console.log(error.response.body);
            //=> 'Internal server error ...'
        }
    })();
}
