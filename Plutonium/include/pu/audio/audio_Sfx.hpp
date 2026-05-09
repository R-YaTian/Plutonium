/**
 * Plutonium library
 * @file audio_Sfx.hpp
 * @brief Sfx (sound effects) support
 * @author XorTroll
 * @copyright XorTroll
 */

#pragma once
#include <pu/pu_Include.hpp> 

struct Mix_Chunk;

namespace pu::audio {

    /**
     * @brief Type representing a sound effect.
     */
    using Sfx = Mix_Chunk*;

    /**
     * @brief Loads a sound effect from the specified path.
     * @note pu::audio::Initialize must be called before using this function.
     * @note The sound effect must be manually freed with pu::audio::DestroySfx when it is no longer needed.
     * @param path Path to the sound effect file.
     * @return Sound effect loaded, or NULL if an error occurred.
     */
    Sfx LoadSfx(const std::string &path);

    /**
     * @brief Plays a sound effect.
     * @note pu::audio::Initialize must be called before using this function.
     * @param sfx Sound effect to play. If NULL is passed, nothing will happen.
     * @return The channel on which the sound effect is being played, or -1 if an error occurred.
     */
    int PlaySfx(Sfx sfx);

    /**
     * @brief Checks if a sound effect is currently playing on the specified channel.
     * @param channel Channel to check.
     * @return Whether a sound effect is currently playing on the specified channel.
     */
    bool IsPlayingSfx(const int channel);

    /**
     * @brief Destroys a sound effect.
     * @param sfx Sound effect to destroy. If NULL is passed, nothing will happen.
     */
    void DestroySfx(Sfx &sfx);

}
