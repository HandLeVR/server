package de.handlevr.server.controller;

import de.handlevr.server.domain.Coat;
import de.handlevr.server.repository.CoatRepository;
import de.handlevr.server.repository.RecordingRepository;
import de.handlevr.server.service.PermissionService;
import org.springframework.http.HttpStatus;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

/**
 * Endpoint for all coat requests.
 */
@RestController
public class CoatController {

    final RecordingRepository recordingRepository;
    final CoatRepository coatRepository;
    final PermissionService permissionService;

    public CoatController(RecordingRepository recordingRepository, CoatRepository coatRepository,
                          PermissionService permissionService) {
        this.recordingRepository = recordingRepository;
        this.coatRepository = coatRepository;
        this.permissionService = permissionService;
    }

    @GetMapping("/coats")
    public List<Coat> getCoats() {
        return coatRepository.findAll();
    }

    @DeleteMapping("/coats/{id}")
    @PreAuthorize("hasAuthority('Teacher') or hasAuthority('RestrictedTeacher')")
    public void deleteCoat(@PathVariable Long id) {
        Coat coat = getCoat(id);
        // we cannot delete a coat if it is used in a recording (or task result)
        if (recordingRepository.existsByCoat(coat) || recordingRepository.existsByBaseCoat(coat))
            throw new ResponseStatusException(HttpStatus.CONFLICT, "RECORDING");
        // we cannot delete a coat if it is used in a task
        if (!coat.getUsedInTasks().isEmpty())
            throw new ResponseStatusException(HttpStatus.CONFLICT, "TASK");
        coatRepository.deleteById(id);
    }

    @GetMapping("/coats/{id}")
    public Coat getCoat(@PathVariable Long id) {
        return coatRepository.findById(id).orElseThrow(() ->
                new ResponseStatusException(HttpStatus.NOT_FOUND, String.format("Coat with the id %s not found", id)));
    }

    @PutMapping(path = "/coats")
    @PreAuthorize("hasAuthority('Teacher') or hasAuthority('RestrictedTeacher')")
    public Coat updateCoat(@RequestBody Coat updatedCoat) {
        Coat coat = getCoat(updatedCoat.getId());
        if (coatRepository.existsByNameAndIdNot(updatedCoat.getName(), updatedCoat.getId()))
            throw new ResponseStatusException(HttpStatus.CONFLICT, "NAME");
        // we cannot update a coat if it is used in a recording (or task result)
        if (recordingRepository.existsByCoat(coat) || recordingRepository.existsByBaseCoat(coat))
            throw new ResponseStatusException(HttpStatus.CONFLICT, "RECORDING");
        updatedCoat.setPermission(permissionService.updatePermission(coat.getPermission()));
        return coatRepository.save(updatedCoat);
    }

    @PostMapping("/coats")
    @PreAuthorize("hasAuthority('Teacher') or hasAuthority('RestrictedTeacher')")
    public Coat createCoat(@RequestBody Coat newCoat) {
        if (coatRepository.existsByName(newCoat.getName()))
            throw new ResponseStatusException(HttpStatus.CONFLICT, "NAME");
        newCoat.setId(null);
        newCoat.setPermission(permissionService.updatePermission(null));
        return coatRepository.save(newCoat);
    }
}