use crate::{
    analyzer::{SymbolId, SymbolInterner, TypeKind}, elaborator::{Environment, EvaluatedValue, Library, LibraryRegistry, Package, SignalId},
};

impl Environment {
    pub fn new() -> Self {
        Self::default()
    }

    /// Creates a new child scope (e.g. when entering a generate loop or sub-instance)
    pub fn extend(&self) -> Self {
        self.clone()
    }

    pub(crate) fn insert_signal(
        &mut self,
        port_sym: SymbolId,
        sig_id: SignalId,
    ) -> Option<SignalId> {
        self.signals.insert(port_sym, sig_id)
    }

    pub(crate) fn insert_constant(
        &mut self,
        sym: SymbolId,
        clone: EvaluatedValue,
    ) -> Option<EvaluatedValue> {
        self.constants.insert(sym, clone)
    }

    pub(crate) fn lookup_signal(&self, target_symbol: SymbolId) -> Option<SignalId> {
        self.signals.get(&target_symbol).copied()
    }

    pub(crate) fn lookup_constant(&self, sym: SymbolId) -> Option<&EvaluatedValue> {
        self.constants.get(&sym)
    }

    /// Merges all exported symbols from a package into the current elaboration scope
    pub fn import_package(&mut self, exports: &Package) {
        for (&sym, val) in &exports.constants {
            self.constants.insert(sym, val.clone());
        }
        for (&sym, &sig_id) in &exports.signals {
            self.signals.insert(sym, sig_id);
        }
    }

    /// Imports a single specific item from a package into the scope
    pub fn import_package_item(&mut self, exports: &Package, item_sym: SymbolId) -> bool {
        let mut imported = false;
        if let Some(val) = exports.constants.get(&item_sym) {
            self.constants.insert(item_sym, val.clone());
            imported = true;
        }
        if let Some(&sig_id) = exports.signals.get(&item_sym) {
            self.signals.insert(item_sym, sig_id);
            imported = true;
        }
        imported
    }
}

impl LibraryRegistry {

    /// Bootstraps the registry with `std.standard` and `ieee.std_logic_1164`
    pub fn initialize_builtins(interner: &mut SymbolInterner) -> Self {
        let mut registry = LibraryRegistry::new();

        // Setup std.standard
        let mut standard_pkg = Package::default();

        // Register Boolean
        let sym_bool = interner.get_or_internalize("boolean");
        let type_bool = registry.types.alloc(TypeKind::Enum {
            name: sym_bool,
            literals: vec![interner.get_or_internalize("false"), interner.get_or_internalize("true")],
        });
        standard_pkg.add_type("boolean", sym_bool, type_bool);

        // Register Integer
        let sym_int = interner.get_or_internalize("integer");
        let type_int = registry.types.alloc(TypeKind::Integer { name: sym_int });
        standard_pkg.add_type("integer", sym_int, type_int);

        // Register real
        let sym_real = interner.get_or_internalize("real");
        let type_real = registry.types.alloc(TypeKind::Real { name: sym_real });
        standard_pkg.add_type("real", sym_real, type_real);
    

        // Add standard package to std library
        let mut std_lib = Library::default();
        std_lib
            .packages
            .insert("standard".to_string(), standard_pkg);
        registry.libraries.insert("std".to_string(), std_lib);

        // Setup ieee.std_logic_1164
        let mut std_logic_pkg = Package::default();

        // Register std_logic
        let sym_sl = interner.get_or_internalize("std_logic");
        let type_sl = registry.types.alloc(TypeKind::Enum {
            name: sym_sl,
            literals: vec![
                interner.get_or_internalize("'U'"),
                interner.get_or_internalize("'X'"),
                interner.get_or_internalize("'0'"),
                interner.get_or_internalize("'1'"),
                interner.get_or_internalize("'Z'"),
                interner.get_or_internalize("'W'"),
                interner.get_or_internalize("'L'"),
                interner.get_or_internalize("'H'"),
                interner.get_or_internalize("'-'"),
            ],
        });
        std_logic_pkg.add_type("std_logic", sym_sl, type_sl);

        // Register std_logic_vector
        let sym_slv = interner.get_or_internalize("std_logic_vector");
        let type_slv = registry.types.alloc(TypeKind::Array {
            name: sym_slv,
            element_type: type_sl,
        });
        std_logic_pkg.add_type("std_logic_vector", sym_slv, type_slv);

        // Add std_logic_1164 package to ieee library
        let mut ieee_lib = Library::default();
        ieee_lib
            .packages
            .insert("std_logic_1164".to_string(), std_logic_pkg);
        registry.libraries.insert("ieee".to_string(), ieee_lib);

        registry
    }
}
