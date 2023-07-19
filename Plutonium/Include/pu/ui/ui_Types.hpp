
/*

    Plutonium library

    @file ui_Types.hpp
    @brief Several basic types helpful for UI and rendering, such as Color
    @author XorTroll

    @copyright Plutonium project - an easy-to-use UI framework for Nintendo Switch homebrew

*/

#pragma once
#include <pu/pu_Macros.hpp>
#include <string>
#include <array>

namespace pu::ui
{
    enum class DefaultFontSize : u32 {
        Small,
        Medium,
        MediumLarge,
        Large,

        Count
    };

    constexpr u32 DefaultFontSizes[static_cast<u32>(DefaultFontSize::Count)] = { 18, 20, 25, 30 };

    inline std::string MakeDefaultFontName(const u32 font_size) {
        return "DefaultFont@" + std::to_string(font_size);
    }

    inline constexpr u32 GetDefaultFontSize(const DefaultFontSize kind) {
        return DefaultFontSizes[static_cast<u32>(kind)];
    }

    inline std::string GetDefaultFont(const DefaultFontSize kind) {
        return MakeDefaultFontName(GetDefaultFontSize(kind));
    }

    struct Color
    {
        u8 R;
        u8 G;
        u8 B;
        u8 A;

        constexpr Color() : R(0), G(0), B(0), A(0xFF) {}

        constexpr Color(u8 R, u8 G, u8 B, u8 A) : R(R), G(G), B(B), A(A) {}

        static Color FromHex(std::string HexFmt);
    };

    static inline constexpr bool TouchHitsRegion(const i32 touch_x, const i32 touch_y, const i32 region_x, const i32 region_y, const i32 region_w, const i32 region_h) {
        return (touch_x >= region_x) && (touch_x < (region_x + region_w)) && (touch_y >= region_y) && (touch_y < (region_y + region_h));
    }

    struct Touch
    {
        i32 X;
        i32 Y;

        inline constexpr bool IsEmpty()
        {
            if(X < 0)
            {
                if(Y < 0)
                {
                    return true;
                }
            }
            return false;
        }

        static const Touch Empty;
    };

    inline constexpr const Touch Touch::Empty = { -1, -1 };

    struct TouchPoint {
        i32 x;
        i32 y;

        constexpr TouchPoint() : x(-1), y(-1) {}
        constexpr TouchPoint(const u32 x, const u32 y) : x(x), y(y) {}

        inline constexpr bool IsEmpty() const {
            return (this->x < 0) && (this->y < 0);
        }

        inline constexpr bool HitsRegion(const i32 region_x, const i32 region_y, const i32 region_w, const i32 region_h) const {
            if(this->IsEmpty())
                return false;
            return TouchHitsRegion(this->x, this->y, region_x, region_y, region_w, region_h);
        }
    };
}
