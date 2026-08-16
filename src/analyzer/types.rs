use std::fmt::Display;

use crate::analyzer::{TypeArena, TypeId, TypeKind};

impl TypeId {
    pub const ERROR: TypeId = TypeId(u32::MAX);

    pub fn is_error(&self) -> bool {
        self.0 == u32::MAX
    }
}


impl TypeArena {
    pub fn alloc(&mut self, kind: TypeKind) -> TypeId {
        let id = TypeId(self.types.len() as u32);
        self.types.push(kind);
        id
    }

    pub fn get(&self, id: TypeId) -> Option<&TypeKind> {
        if id == TypeId::ERROR {
            return None;
        }
        self.types.get(id.0 as usize)
    }
}
impl Display for TypeArena{
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        for i in &self.types{
        }
        todo!()
    }
}
