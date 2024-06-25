function playObj = play_audio(y,FS,OutID)
% play audio signal
%
% usage:
%   play_audio(y,FS,OutID)
%   y     : signal to be played back
%   FS    : sampling rate 
%   OutID : output device id

fprintf('Playing audio signal from device OutID=%i...\n',OutID)
playObj = audioplayer(y,FS,16,OutID);
play(playObj);
%playblocking(sound);

% note that play is nonblocking and the lifetime of the sound object is
% only for the lifetime of the function so we have to pass it back...

end

