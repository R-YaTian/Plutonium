#include <SDL2/SDL_mixer.h>
#include <pu/audio/audio_Audio.hpp>

namespace pu::audio {

    bool Initialize(int init_flags) {
        if(init_flags != 0 && Mix_Init(init_flags) != init_flags) {
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
