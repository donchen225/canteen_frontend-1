const fetch = require('node-fetch');

const ZOOM_BASE_URL = 'https://api.zoom.us/v2/';

const ZOOM_USER_ID = 'D3HzE_hfR5yJ6Kyv5QqaDA';

const ZOOM_REQUEST_BODY = {
    "topic": "", // "test-meeting-10"
    "type": "2",
    "start_time": "", // "2020-04-15T18:10:00"
    "duration": "", // "30"
    "timezone": "America/Los_Angeles",
    "agenda": "", //"test agenda"
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

// TODO: set up function to retrieve JWT token
// Either don't expire token or set function to rotate tokens
exports.sendZoomRequest = async (topic, agenda, startTime, duration) => {

    var zoomRequest = JSON.parse(JSON.stringify(ZOOM_REQUEST_BODY));
    zoomRequest['topic'] = topic;
    zoomRequest['agenda'] = agenda;
    zoomRequest['start_time'] = startTime;
    zoomRequest['duration'] = duration;

    try {
        return await fetch(ZOOM_BASE_URL + `users/${ZOOM_USER_ID}/meetings`,
            {
                method: 'post',
                headers: {
                    'Authorization': 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOm51bGwsImlzcyI6IklIWEs4RHh6UWxLQWttajc3NThaRmciLCJleHAiOjE1ODgxODEzNDIsImlhdCI6MTU4NzU3NjU0Mn0.03qnIS5W5LjL6PlXFSho-DxKU4QocDj8bWQ62Xwtlt0',
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(zoomRequest),
            }).then(res => res.json()).then((json) => {
                return json;
            });


    } catch (error) {
        console.log(error);
        //=> 'Internal server error ...'
    }
    return {};
}
