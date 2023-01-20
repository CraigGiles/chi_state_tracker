// -----------------------------------------------------------------
// Last Change: Jan 1, 2023
// JAI version: v0.1.053
// Maintainer : Craig Giles
// License    : This file uses the MIT license. See LICENSE.md for info.
// -----------------------------------------------------------------
#import "Basic";

state_equals :: (state: $T) -> bool {
    info := find_info(state);

    for info.states {
        if it == state {
            if info.current_state == it_index then return true;
            else return false;
        }
    }
    return false;
}

is_at_state :: (state: $T) -> bool {
    return state_equals(state);
}

has_reached_state :: (state: $T) -> bool {
    info := find_info(state);
    for info.states {
        if it == state {
            if info.current_state >= it_index then return true;
            else return false;
        }
    }
    return false;
}

is_between_state :: (first: $T, second: $U) -> bool {
    if has_reached_state(first) && !has_reached_state(second) then return true;
    if !has_reached_state(first) && has_reached_state(second) then return true;

    return false;
}

move_to_state :: (state: $T, print_state_change := false) {
    info := find_info(state);

    for info.states {
        if it == state {
            if info.current_state < it_index then {
                info.current_state = it_index;
                info.current_state_name = enum_names(T)[it_index];

                if print_state_change {
                    log("STATE TRACKER: Changed % To State %", info.name, info.current_state_name);
                }
            }

            assert(it_index != 0); // NOTE: dont want to reset the state back to null
            return;
        }
    }

    assert(false, "Unknown state reached");
}

reset_all_tracked_states :: () {
    for all_states {
        free(it);
        remove it;
    }

    array_reset(*all_states);
}

#scope_file // -----------------------------------------------------------------

all_states:    [..] *StateName;

// This function was passed around the beta discord and it made the StateInfo struct nicer.
// Thanks to 'shwa' !!
ModifyRequire :: (t: Type, kind: Type_Info_Tag) #expand {
    `return (cast(*Type_Info)t).type == kind, tprint("T must be %", kind);
}

StateName :: struct {
    name: string;
    current_state: s64 = 0;
}

StateInfo :: struct ($T: Type) #modify ModifyRequire(T, .ENUM) {
    using #as state_name: StateName;

    STATE_COUNT :: #run enum_names(T).count;
    states: [STATE_COUNT] T = #run enum_values_as_enum(T);

    name = #run type_info(T).name;
    current_state_name: string = #run enum_names(T)[0];
}

find_info :: (state: $T) -> *StateInfo(T) {
    for all_states {
        name := #run type_info(T).name;
        if name == it.name {
            info := cast(*StateInfo(T))it;
            return info;
        }
    }

    // if code reaches here, the state was never loaded.
    log("STATE TRACKER: Loading state for %.", T);

    result := New(StateInfo(T));
    array_add(*all_states, result);

    return result;
}
