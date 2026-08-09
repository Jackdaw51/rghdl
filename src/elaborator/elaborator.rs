use crate::{
    analyzer::{
        SemanticAnalyzer,
        scope_tree::{DeclRef, ScopeId},
    },
    elaborator::{ElaboratedArena, Elaborator, ElaboratorError, InstanceId},
    parser::ast::{ArchitectureId, AstArena, EntityId},
};

impl<'a> Elaborator<'a> {
    pub fn new(ast: &'a AstArena<'a>, sa: &'a SemanticAnalyzer<'a>) -> Self {
        Self {
            ast,
            sa,
            arena: ElaboratedArena::default(),
            instance_counter: 0,
        }
    }
    /// The main entry point. Finds the top-level entity and builds the hardware tree.
    pub fn elaborate(&mut self, top_entity_name: &str) -> Result<InstanceId, ElaboratorError> {
        let entity_id = self
            .find_entity(top_entity_name)
            .ok_or_else(|| ElaboratorError::EntityNotFound(top_entity_name.to_string()))?;

        let arch_id = self
            .find_architecture_for_entity(entity_id)
            .ok_or_else(|| ElaboratorError::ArchitectureNotFound(top_entity_name.to_string()))?;

        self.elaborate_architecture(entity_id, arch_id, None)
    }

    /// Recursively builds a physical hardware instance from an AST Entity/Architecture pair.
    fn elaborate_architecture(
        &mut self,
        entity_id: EntityId,
        arch_id: ArchitectureId,
        parent: Option<InstanceId>,
    ) -> Result<InstanceId, ElaboratorError> {
        let entity = &self.ast.entities[entity_id.0 as usize];
        let arch = &self.ast.architectures[arch_id.0 as usize];

        // Create a new unique ID for this hardware instance
        let current_instance_id = self.get_instance_id();

        // TODO: 1. Elaborate Ports (Create physical pins for this chip)

        // TODO: 2. Elaborate Declarations (Lay down internal wiring)

        // TODO: 3. Elaborate Concurrent Statements (Instantiate child chips, processes, and continuous assignments)

        // Register the finished chip in our elaborated arena
        // self.arena.instances.insert(current_instance_id, new_instance_node);

        Ok(current_instance_id)
    }

    fn get_instance_id(&mut self) -> InstanceId {
        let current_instance_id = InstanceId(self.instance_counter);
        self.instance_counter += 1;
        current_instance_id
    }

    fn find_entity(&self, name: &str) -> Option<EntityId> {
        // If not, it can't possibly exist in the source code.
        let sym_id = self.sa.symbols.interner.get(name)?;

        let global_scope = ScopeId(0);
        let decl_ref = self.sa.symbols.lookup(global_scope, sym_id)?;

        match decl_ref {
            DeclRef::Entity { entity_id, .. } => Some(entity_id),
            _ => None, // The name exists, but it's not an Entity (it could be a package)
        }
    }
    fn find_architecture_for_entity(&self, target_entity: EntityId) -> Option<ArchitectureId> {
        self.sa
            .entity_architectures
            .get(&target_entity)
            .and_then(|ids| ids.last())
            .copied()
    }
}
