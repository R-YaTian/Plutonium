#include <SDL2/SDL_mixer.h>
#include <pu/audio/audio_Audio.hpp>

namespace pu::audio {

    bool Initialize(bool init_midi) {
        if(init_midi && Mix_Init(MIX_INIT_MID) != MIX_INIT_MID) {
            return false;
        }

        if(Mix_OpenAudio(44100, MIX_DEFAULT_FORMAT, MIX_DEFAULT_CHANNELS, 4096) == -1) {
            return false;
        }   
    
        return true;
    }

    void Finalize() {
        Mix_CloseAudio();
        Mix_Quit();
    }

}
