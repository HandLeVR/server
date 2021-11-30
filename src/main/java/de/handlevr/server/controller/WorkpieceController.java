package de.handlevr.server.controller;

import de.handlevr.server.domain.Workpiece;
import de.handlevr.server.repository.WorkpieceRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
public class WorkpieceController {

    @Autowired
    WorkpieceRepository workpieceRepository;

    @GetMapping("/workpieces")
    public List<Workpiece> getWorkpieces() {
        return workpieceRepository.findAll();
    }
}
