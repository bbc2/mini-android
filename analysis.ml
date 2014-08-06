let fixpoint eq transfer l0 =
  let rec iter l =
    let l' = transfer l in
    if eq l l' then
      l
    else
      iter l' in
  iter l0
