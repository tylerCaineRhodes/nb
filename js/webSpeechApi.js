const synth = speechSynthesis;
const voices = synth.getVoices();

const utterance = new SpeechSynthesisUtterance("say something cool");
utterance.voice = voices[0];
synth.speak(utterance);

const differentVoiceUtterance = new SpeechSynthesisUtterance(
  "say something in a different voice",
);
differentVoiceUtterance.voice = voices[1];
synth.speak(differentVoiceUtterance);

const differentRateUtterance = new SpeechSynthesisUtterance(
  "say something at a different rate",
);
differentRateUtterance.rate = 2;

synth.speak(differentRateUtterance);

const differentPitchUtterance = new SpeechSynthesisUtterance(
  "say something at a different pitch",
);
differentPitchUtterance.pitch = 2;

synth.speak(differentPitchUtterance);

const differentVolumeUtterance = new SpeechSynthesisUtterance(
  "say something at a different volume",
);
differentVolumeUtterance.volume = 0.5;

synth.speak(differentVolumeUtterance);

