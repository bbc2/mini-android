let fixpoint transfer l0 =
  let rec iter l =
    let l' = transfer l in
    if Local.equal l l' then
      l
    else
      iter l' in
  iter l0
