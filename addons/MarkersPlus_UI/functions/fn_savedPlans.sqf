// Expand storage without rewriting the old registry. An intentionally empty
// v2 registry must stay empty rather than resurrecting deleted v1 plans.
profileNamespace getVariable ["mplus_plans_v2",profileNamespace getVariable ["mplus_plans_v1",[]]]
