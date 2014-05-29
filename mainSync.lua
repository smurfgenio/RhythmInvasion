local tempo=120 -- in BPM
local tempoMS=60000/tempo/4 -- for 16ths at 95.5bpm we'll divide by 4... for normal quarter-note beats, remove the "/4" from the end of the line
 
local click = audio.loadSound("tick1.wav")
 
local timerLocal = system.getTimer  
local timestarted=timerLocal()
local next_beat=timestarted+tempoMS
local teclaApertada = {}
 
print ("tempoMS (beat length): "..tempoMS.."\n")
 
local counter=1;
 
local function checkBeat()
   local thetime = timerLocal()
   local index=math.max(0,16-(math.floor(thetime-next_beat)))
   if thetime>next_beat then
      audio.play(click)
      print ("only off target ticks by "..math.floor(thetime-next_beat).. "ms") --this is the amount of milliseconds we are off the perfect system time target that will never go out of phase
      print ("timestarted: "..timestarted.." thetime: "..thetime.." next_beat:"..next_beat)
      --checar as teclas apertadas e verificar a diferença entre o current beat
      for _,item in ipairs( teclaApertada ) do
        print(item[1] .. "  " .. item[2])
      end
 
      --Begin playback integrity check
      if thetime>next_beat+tempoMS then -- i.e. we are behind two beats because of some kind of overload
        print("OH NO! Tempo has gone out of phase due to an interruption in the runtime or perhaps the audio engine, etc")
        --playback could be halted here, too
      end 
      --End playback integrity check
 
      counter=counter+1
      next_beat=next_beat+tempoMS
      --the above line could also be expressed as next_beat=timestarted+(counter*tempoMS) to find the timing for a specific beat number, the number of which is represented here by "counter"
   end
end
 
local function checkStroke(event)
  teclaApertada[#teclaApertada+1] = {event.keyName,timerLocal()}
end 
 
Runtime:addEventListener("enterFrame",checkBeat) 
Runtime:addEventListener( "key", checkStroke ) 
--timer.performWithDelay(1,checkBeat,0)  
--this should work better in theory, but doesn't. comment out the Runtime:... line above if you try this method over the enterFrame