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

    typedef enum
    {
        INIT_MP3    = 0x00000008,
        INIT_MID    = 0x00000020,
        INIT_ALL    = (INIT_MP3 | INIT_MID),
    } InitFlags;

    /**
     * @brief Initializes the underlying audio system (SDL2-Mixer) with the specified flags.
     * @param init_flags Flags to specify which audio systems to initialize (e.g., MIDI, MP3).
     * @return Whether the audio system was initialized successfully.
     */
    bool Initialize(int init_flags = 0);

    /**
     * @brief Finalizes the underlying audio system (SDL2-Mixer).
     */
    void Finalize();

}
