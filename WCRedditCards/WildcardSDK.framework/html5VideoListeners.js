for (var i = 0, videos = document.getElementsByTagName('video'); i < videos.length; i++) {
    videos[i].addEventListener('webkitbeginfullscreen', function(){
                               window.webkit.messageHandlers.observe.postMessage('webkitbeginfullscreen');
                               }, false);
    
    videos[i].addEventListener('webkitendfullscreen', function(){
                               window.webkit.messageHandlers.observe.postMessage('webkitendfullscreen');
                               }, false);
}