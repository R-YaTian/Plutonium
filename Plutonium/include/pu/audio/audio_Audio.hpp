/**
 * Plutonium library
 * @file audio_Audio.hpp
 * @brief Main audio header
 * @author XorTroll
 * @copyright XorTroll
*/

#pragma once
#include <pu/audio/audio_Music.hpp>
#include <pu/audio/audio_Sfx.hpp>

namespace pu::audio {

    /**
     * @brief Initializes the underlying audio system (SDL2-Mixer) with the specified flags.
     * @param init_midi Whether to initialize the MIDI audio system.
     * @return Whether the audio system was initialized successfully.
     */
    bool Initialize(bool init_midi = false);

    /**
     * @brief Finalizes the underlying audio system (SDL2-Mixer).
     */
    void Finalize();

}
