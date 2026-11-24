//
//  Asteroid.h
//  Asteroid
//
//  Created by Taj C on 8/20/26.
//

/*
     Asteroid - A sandbox escape PoC for iOS 26 and 27, again.
     Copyright (C) 2026 Taj C (forcequit)

     This program is free software: you can redistribute it and/or modify
     it under the terms of the GNU General Public License as published by
     the Free Software Foundation, either version 3 of the License, or
     (at your option) any later version.

     This program is distributed in the hope that it will be useful,
     but WITHOUT ANY WARRANTY; without even the implied warranty of
     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
     GNU General Public License for more details.

     You should have received a copy of the GNU General Public License
     along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

#ifndef Asteroid_h
#define Asteroid_h

#import <Foundation/Foundation.h>
#include <stdint.h>
#include <stdbool.h>

int64_t Asteroid(NSString *path, NSString *group, bool alt_flags, bool create_dir);
void Asteroid_release(int64_t handle);

#endif /* Asteroid_h */
